#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="cleanup-screenshots"
SCREENSHOTS_DIR="$HOME/Pictures/screenshots"
DRY_RUN=false
VERBOSE=false
DAYS_OLD=30

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Clean up screenshot files older than $DAYS_OLD days.

OPTIONS:
    --dry-run       Show what would be deleted without actually deleting
    --verbose       Show detailed output
    --days DAYS     Number of days (default: $DAYS_OLD)
    --help          Show this help message

EXAMPLES:
    $0 --dry-run                    # Show what would be deleted
    $0 --verbose                    # Delete with detailed output
    $0 --days 60 --dry-run          # Show files older than 60 days
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
        --days)
            DAYS_OLD="$2"
            shift 2
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

if [[ ! -d "$SCREENSHOTS_DIR" ]]; then
    log "Screenshots directory does not exist: $SCREENSHOTS_DIR"
    exit 1
fi

verbose_log "Looking for PNG files in $SCREENSHOTS_DIR older than $DAYS_OLD days"

files_to_delete=()
while IFS= read -r -d '' file; do
    files_to_delete+=("$file")
done < <(find "$SCREENSHOTS_DIR" -type f -name "*.png" -mtime "+$DAYS_OLD" -print0 2>/dev/null)

if [[ ${#files_to_delete[@]} -eq 0 ]]; then
    verbose_log "No files found older than $DAYS_OLD days"
    exit 0
fi

log "Found ${#files_to_delete[@]} files older than $DAYS_OLD days"

if [[ "$VERBOSE" == "true" ]]; then
    for file in "${files_to_delete[@]}"; do
        file_date=$(ls -l "$file" | awk '{print $6, $7, $8}')
        log "  $file (modified: $file_date)"
    done
fi

if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN: Would delete ${#files_to_delete[@]} files"
    exit 0
fi

deleted_count=0
for file in "${files_to_delete[@]}"; do
    if rm "$file"; then
        verbose_log "Deleted: $file"
        deleted_count=$((deleted_count + 1))
    else
        log "ERROR: Failed to delete $file - stopping script"
        log "Successfully deleted $deleted_count out of ${#files_to_delete[@]} files before error"
        exit 1
    fi
done

log "Successfully deleted $deleted_count out of ${#files_to_delete[@]} files"