#!/usr/bin/env bash
#
# update-skills.sh — 检查上游 skills 仓库是否更新，并同步到本仓库。
#
# 用法:
#   ./update-skills.sh --check  只检查上游是否有更新，不改动本地文件
#                               （有更新时退出码为 2，可配合 cron 使用）
#   ./update-skills.sh --sync   同步有更新的源（默认动作；仅克隆变更的仓库）
#   ./update-skills.sh --commit 同步后自动 git commit
#   ./update-skills.sh --push   同步后 commit + push
#
# 依赖: git、rsync、网络。清单见 skills-sync.tsv，最近同步记录见 .skills-sync-state.tsv。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
MANIFEST="$SCRIPT_DIR/skills-sync.tsv"
STATE="$SCRIPT_DIR/.skills-sync-state.tsv"

MODE="sync"
DO_COMMIT=0
DO_PUSH=0

usage() {
    sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

for arg in "$@"; do
    case "$arg" in
        --check) MODE="check" ;;
        --sync)  MODE="sync" ;;
        --commit) DO_COMMIT=1 ;;
        --push)   DO_COMMIT=1; DO_PUSH=1 ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $arg" >&2; usage ;;
    esac
done

command -v git >/dev/null || { echo "git not found" >&2; exit 1; }
command -v rsync >/dev/null || { echo "rsync not found" >&2; exit 1; }

# 解析上游默认分支（ref 列为 default 时）
resolve_branch() {
    local repo="$1" ref="$2"
    if [ "$ref" != "default" ]; then
        echo "$ref"
        return
    fi
    git ls-remote --symref "$repo" HEAD 2>/dev/null \
        | awk '$1 == "ref:" { print $2; exit }' \
        | sed 's|^refs/heads/||'
}

upstream_sha() {
    local repo="$1" branch="$2"
    git ls-remote "$repo" "refs/heads/$branch" 2>/dev/null | cut -f1 || true
}

read_state_sha() {
    local local_dir="$1" repo="$2"
    [ -f "$STATE" ] || return 0
    awk -F'|' -v d="$local_dir" -v r="$repo" '$1 == d && $2 == r { print $4; exit }' "$STATE"
}

write_state() {
    local local_dir="$1" repo="$2" branch="$3" sha="$4"
    local tmp
    tmp="$(mktemp)"
    if [ -f "$STATE" ]; then
        awk -F'|' -v d="$local_dir" -v r="$repo" '$1 != d || $2 != r' "$STATE" > "$tmp"
    else
        : > "$tmp"
    fi
    printf '%s|%s|%s|%s|%s\n' "$local_dir" "$repo" "$branch" "$sha" "$(date +%Y-%m-%d)" >> "$tmp"
    mv "$tmp" "$STATE"
}

sync_entry() {
    local local_dir="$1" repo_url="$2" mode="$3" src="$4" root_files="$5"
    local clone_dir
    clone_dir="$(mktemp -d "${TMPDIR:-/tmp}/skills-sync.XXXXXX")"
    trap 'rm -rf "$clone_dir"' RETURN

    git clone --depth 1 --quiet --branch "$branch" "$repo_url" "$clone_dir" || {
        echo "  [FAIL] clone $repo_url" >&2
        return 1
    }

    mkdir -p "$SCRIPT_DIR/$local_dir"

    case "$mode" in
        subdirs)
            IFS=',' read -r -a paths <<< "$src"
            for p in "${paths[@]}"; do
                if [ ! -d "$clone_dir/$p" ]; then
                    echo "  [WARN] $repo: source path missing: $p" >&2
                    continue
                fi
                rsync -a --delete "$clone_dir/$p/" "$SCRIPT_DIR/$local_dir/$(basename "$p")/"
            done
            ;;
        dir)
            if [ ! -d "$clone_dir/$src" ]; then
                echo "  [FAIL] $repo: source path missing: $src" >&2
                return 1
            fi
            rsync -a --delete --exclude README.md "$clone_dir/$src/" "$SCRIPT_DIR/$local_dir/"
            ;;
        root)
            rsync -a --delete --exclude .git --exclude README.md "$clone_dir/" "$SCRIPT_DIR/$local_dir/"
            ;;
        *)
            echo "  [FAIL] unknown mode: $mode" >&2
            return 1
            ;;
    esac

    if [ -n "$root_files" ]; then
        IFS=',' read -r -a files <<< "$root_files"
        for f in "${files[@]}"; do
            if [ -f "$clone_dir/$f" ]; then
                cp "$clone_dir/$f" "$SCRIPT_DIR/$local_dir/$f"
            fi
        done
    fi

    # 本地 overlay：同步后再覆盖本地维护的增强文件（不删除上游新增文件）
    if [ -n "$overlay" ] && [ -d "$SCRIPT_DIR/$overlay" ]; then
        rsync -a "$SCRIPT_DIR/$overlay/" "$SCRIPT_DIR/$local_dir/"
        echo "  [overlay] applied $overlay"
    fi
}

# ---- 主流程 ----
[ -f "$MANIFEST" ] || { echo "manifest not found: $MANIFEST" >&2; exit 1; }

changed=0
synced=()

while IFS=$'\t' read -r local_dir repo ref mode src root_files overlay; do
    [ -n "$local_dir" ] || continue
    case "$local_dir" in \#*) continue ;; esac
    # 跳过表头行
    [ "$local_dir" = "local_dir" ] && continue

    repo_url="https://github.com/$repo"
    branch="$(resolve_branch "$repo_url" "$ref" || true)"
    if [ -z "$branch" ]; then
        echo "[WARN] cannot resolve branch for $repo" >&2
        continue
    fi
    sha="$(upstream_sha "$repo_url" "$branch" || true)"
    if [ -z "$sha" ]; then
        echo "[WARN] cannot reach $repo" >&2
        continue
    fi

    last="$(read_state_sha "$local_dir" "$repo")"

    if [ "$MODE" = "check" ]; then
        if [ "$last" = "$sha" ]; then
            printf '%-34s up-to-date  %s\n' "$local_dir" "$sha"
        else
            changed=2
            printf '%-34s UPDATED     %s -> %s\n' "$local_dir" "${last:-new}" "$sha"
        fi
        continue
    fi

    if [ "$last" = "$sha" ]; then
        printf '%-34s up-to-date  %s\n' "$local_dir" "$sha"
        continue
    fi

    printf '%-34s syncing      %s -> %s\n' "$local_dir" "${last:-new}" "$sha"
    if sync_entry "$local_dir" "$repo_url" "$mode" "$src" "$root_files"; then
        write_state "$local_dir" "$repo" "$branch" "$sha"
        synced+=("$local_dir")
    else
        changed=2
    fi
done < "$MANIFEST"

if [ "$MODE" = "check" ]; then
    exit "$changed"
fi

if [ "${#synced[@]}" -gt 0 ]; then
    echo
    echo "Synced ${#synced[@]} source(s): ${synced[*]}"
    if [ "$DO_COMMIT" -eq 1 ]; then
        git -C "$SCRIPT_DIR" add -A
        git -C "$SCRIPT_DIR" commit --quiet -m "sync skills from upstream: ${synced[*]}" || true
        echo "Committed."
        if [ "$DO_PUSH" -eq 1 ]; then
            git -C "$SCRIPT_DIR" push
            echo "Pushed."
        fi
    else
        echo "Working tree updated. Review with 'git status', then commit, or rerun with --commit."
    fi
else
    echo "All sources up to date."
fi

exit 0
