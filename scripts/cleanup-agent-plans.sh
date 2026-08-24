#!/run/current-system/sw/bin/bash

set -euo pipefail

SCRIPT_NAME="cleanup-agent-plans"
ROOT="$HOME/seriousben-agent-plans"
DRY_RUN=false
VERBOSE=false
DAYS_OLD=14

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Delete per-repo folders and loose files directly under $ROOT that have gone
untouched for more than $DAYS_OLD days. An entry is untouched when neither it,
its subfolders, nor any file inside was modified within the threshold.

OPTIONS:
    --dry-run       Show what would be deleted without deleting
    --verbose       Show detailed output
    --help          Show this help message
EOF
}

log() {
    echo "[$SCRIPT_NAME] $*" >&2
}

verbose_log() {
    if [[ "$VERBOSE" == "true" ]]; then
        log "$@"
    fi
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [[ ! -d "$ROOT" ]]; then
    verbose_log "Root does not exist, nothing to do: $ROOT"
    exit 0
fi

# An entry (folder or loose file) is stale when neither it, its subfolders, nor
# any file inside was touched within DAYS_OLD days.
is_stale() {
    [[ -z "$(find "$1" -newermt "-${DAYS_OLD} days" -print -quit 2>/dev/null)" ]]
}

deleted=0
for entry in "$ROOT"/*; do
    [[ -e "$entry" ]] || continue
    if is_stale "$entry"; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log "DRY RUN: would delete $entry"
        else
            rm -rf "$entry"
            verbose_log "Deleted $entry"
        fi
        deleted=$((deleted + 1))
    else
        verbose_log "Keeping active entry: $entry"
    fi
done

log "Deleted $deleted stale entries"
