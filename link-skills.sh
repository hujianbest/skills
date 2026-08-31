#!/usr/bin/env bash
set -euo pipefail

TARGETS="claude,opencode,hermes"
ONLY=""
REMOVE=0
FORCE=0

usage() {
    cat <<'EOF'
Usage: ./link-skills.sh [options]

Options:
  --targets <list>   Comma-separated targets: claude,opencode,hermes (default: all)
  --only <list>      Comma-separated skill names to process (default: all)
  --force            Replace existing links that point to a different target
  --remove           Remove links instead of creating them
  -h, --help         Show this help
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --targets) TARGETS="$2"; shift 2 ;;
        --only)    ONLY="$2"; shift 2 ;;
        --force)   FORCE=1; shift ;;
        --remove)  REMOVE=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
    esac
done

IFS=',' read -r -a TARGET_LIST <<< "$TARGETS"
for t in "${TARGET_LIST[@]}"; do
    case "$(echo "$t" | xargs)" in
        claude|opencode|hermes) ;;
        *) echo "Unknown target: $t (valid: claude, opencode, hermes)" >&2; exit 1 ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

declare -A TARGET_PATHS=(
    [claude]="$HOME/.claude/skills"
    [opencode]="$HOME/.config/opencode/skills"
    [hermes]="$HOME/.hermes/skills"
)

mapfile -t SKILLS < <(
    find "$SCRIPT_DIR" -mindepth 2 -maxdepth 4 -name SKILL.md -not -path '*/.git/*' -not -path '*/overlays/*' \
        | while read -r f; do dirname "$f"; done \
        | sort -u
)

if [[ -n "$ONLY" ]]; then
    IFS=',' read -r -a ONLY_LIST <<< "$ONLY"
    FILTERED=()
    for s in "${SKILLS[@]}"; do
        name="$(basename "$s")"
        for o in "${ONLY_LIST[@]}"; do
            if [[ "$name" == "$(echo "$o" | xargs)" ]]; then
                FILTERED+=("$s")
                break
            fi
        done
    done
    SKILLS=("${FILTERED[@]}")
fi

if [[ ${#SKILLS[@]} -eq 0 ]]; then
    echo "No matching skills found" >&2
    exit 1
fi

echo "Found ${#SKILLS[@]} skills in $SCRIPT_DIR"

for target in "${TARGET_LIST[@]}"; do
    target="$(echo "$target" | xargs)"
    target_dir="${TARGET_PATHS[$target]}"

    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
        echo "[$target] created $target_dir"
    fi

    for skill in "${SKILLS[@]}"; do
        name="$(basename "$skill")"
        link_path="$target_dir/$name"

        if [[ "$REMOVE" -eq 1 ]]; then
            if [[ -L "$link_path" ]]; then
                rm "$link_path"
                echo "[$target] removed link: $name"
            elif [[ -e "$link_path" ]]; then
                echo "[$target] skip $name: real directory, not a link" >&2
            fi
            continue
        fi

        if [[ -L "$link_path" ]]; then
            existing="$(readlink "$link_path")"
            if [[ "$existing" == "$skill" ]]; then
                echo "[$target] ok (already linked): $name"
                continue
            fi
            if [[ "$FORCE" -eq 1 ]]; then
                rm "$link_path"
            else
                echo "[$target] skip $name: link exists with different target (use --force to replace)" >&2
                continue
            fi
        elif [[ -e "$link_path" ]]; then
            echo "[$target] skip $name: $link_path already exists and is a real directory" >&2
            continue
        fi

        ln -s "$skill" "$link_path"
        echo "[$target] linked (symlink): $name -> $link_path"
    done
done
