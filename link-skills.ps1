#Requires -Version 5.1
[CmdletBinding(DefaultParameterSetName = 'link')]
param(
    [Parameter(ParameterSetName = 'remove')]
    [switch]$Remove,

    [switch]$Force,

    [ValidateSet('claude', 'opencode', 'hermes')]
    [string[]]$Targets = @('claude', 'opencode', 'hermes'),

    [string[]]$Only
)

$ErrorActionPreference = 'Stop'

$KnownTargets = @('claude', 'opencode', 'hermes')

function Split-ListValue {
    param([string[]]$Values)

    @($Values | ForEach-Object { $_ -split '\s*,\s*' } | Where-Object { $_ })
}

$Targets = Split-ListValue $Targets
if (@($Targets | Where-Object { $_ -notin $KnownTargets })) {
    throw "Unknown target(s): $((@($Targets | Where-Object { $_ -notin $KnownTargets })) -join ', '). Valid: $($KnownTargets -join ', ')"
}
$Only = Split-ListValue $Only

$TargetPaths = [ordered]@{
    claude   = Join-Path $HOME '.claude\skills'
    opencode = Join-Path $HOME '.config\opencode\skills'
    hermes   = Join-Path $HOME '.hermes\skills'
}

$root = $PSScriptRoot

$skills = @(
    Get-ChildItem -LiteralPath $root -Directory |
        Where-Object { $_.Name -ne '.git' } |
        ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Directory } |
        ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Directory } |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf }
)
$skills += @(
    Get-ChildItem -LiteralPath $root -Directory |
        Where-Object { $_.Name -ne '.git' } |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf }
)
$skills = @($skills | Sort-Object FullName -Unique)

if ($Only) {
    $skills = @($skills | Where-Object { $_.Name -in $Only })
    if (-not $skills) {
        Write-Warning "No matching skills for: $($Only -join ', ')"
        exit 1
    }
}

Write-Host "Found $($skills.Count) skills in $root"

function Test-SameTarget {
    param([string]$LinkPath, [string]$SkillPath)

    $item = Get-Item -LiteralPath $LinkPath -Force -ErrorAction SilentlyContinue
    if (-not $item -or -not $item.LinkType) { return $false }

    $existing = $item.Target
    if (-not $existing -and $item.LinkType -eq 'Junction') {
        $existing = ([System.IO.DirectoryInfo]$item).LinkTarget
    }
    if (-not $existing) { return $false }

    $existing = [System.IO.Path]::GetFullPath($existing)
    return ($existing.TrimEnd('\') -ieq $SkillPath.TrimEnd('\'))
}

function Remove-DirLink {
    param([string]$Path)

    Remove-Item -LiteralPath $Path -Force -Recurse -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $Path) {
        [System.IO.Directory]::Delete($Path, $false)
    }
}

function New-DirLink {
    param([string]$LinkPath, [string]$SkillPath)

    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Value $SkillPath -ErrorAction Stop | Out-Null
        return 'symlink'
    }
    catch {
        New-Item -ItemType Junction -Path $LinkPath -Value $SkillPath | Out-Null
        return 'junction'
    }
}

foreach ($name in $Targets) {
    $targetDir = $TargetPaths[$name]
    if (-not (Test-Path -LiteralPath $targetDir -PathType Container)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        Write-Host "[$name] created $targetDir"
    }

    foreach ($skill in $skills) {
        $linkPath = Join-Path $targetDir $skill.Name

        if ($Remove) {
            if (Test-Path -LiteralPath $linkPath) {
                $item = Get-Item -LiteralPath $linkPath -Force
                if ($item.LinkType) {
                    Remove-DirLink -Path $linkPath
                    Write-Host "[$name] removed link: $($skill.Name)"
                }
                else {
                    Write-Warning "[$name] skip $($skill.Name): real directory, not a link"
                }
            }
            continue
        }

        if (Test-SameTarget -LinkPath $linkPath -SkillPath $skill.FullName) {
            Write-Host "[$name] ok (already linked): $($skill.Name)"
            continue
        }

        if (Test-Path -LiteralPath $linkPath) {
            $item = Get-Item -LiteralPath $linkPath -Force
            if ($item.LinkType) {
                if (-not $Force) {
                    Write-Warning "[$name] skip $($skill.Name): link exists with different target (use -Force to replace)"
                    continue
                }
                Remove-DirLink -Path $linkPath
            }
            else {
                Write-Warning "[$name] skip $($skill.Name): $linkPath already exists and is a real directory"
                continue
            }
        }

        $kind = New-DirLink -LinkPath $linkPath -SkillPath $skill.FullName
        Write-Host "[$name] linked ($kind): $($skill.Name) -> $linkPath"
    }
}
