#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="organize-downloads"
DOWNLOADS_DIR="$HOME/Downloads"
DRY_RUN=false
VERBOSE=false
DAYS_OLD=30

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Organize downloads by moving files older than $DAYS_OLD days into monthly folders.

Monthly folders are created in format YYYY-MM (e.g., 2024-07, 2024-08).
Files newer than $DAYS_OLD days remain in the main Downloads folder.

OPTIONS:
    --dry-run       Show what would be moved without actually moving
    --verbose       Show detailed output
    --days DAYS     Number of days (default: $DAYS_OLD)
    --help          Show this help message

EXAMPLES:
    $0 --dry-run                    # Show what would be organized
    $0 --verbose                    # Organize with detailed output
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

get_monthly_folder() {
    local file="$1"
    local file_date
    
    # Parse the modify time from stat output (most portable)
    local modify_line
    local stat_output
    if stat_output=$(stat "$file" 2>/dev/null); then
        modify_line=$(echo "$stat_output" | grep "Modify:" | head -1 || true)
    else
        modify_line=""
    fi
    
    if [[ -n "$modify_line" ]]; then
        file_date=$(echo "$modify_line" | sed 's/Modify: //' | cut -d' ' -f1 | cut -d'-' -f1-2)
        # Validate the date format
        if [[ ! "$file_date" =~ ^[0-9]{4}-[0-9]{2}$ ]]; then
            file_date=$(date "+%Y-%m")
        fi
    else
        # Fallback to current date
        file_date=$(date "+%Y-%m")
    fi
    
    echo "$DOWNLOADS_DIR/$file_date"
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

if [[ ! -d "$DOWNLOADS_DIR" ]]; then
    log "Downloads directory does not exist: $DOWNLOADS_DIR"
    exit 1
fi

verbose_log "Looking for files in $DOWNLOADS_DIR older than $DAYS_OLD days"

files_to_organize=()
while IFS= read -r -d '' file; do
    # Skip directories and already organized monthly folders
    if [[ -f "$file" && "$(basename "$file")" != .* && ! "$file" =~ /[0-9]{4}-[0-9]{2}/[^/]*$ ]]; then
        files_to_organize+=("$file")
    fi
done < <(find "$DOWNLOADS_DIR" -maxdepth 1 -type f -mtime "+$DAYS_OLD" -print0 2>/dev/null)

if [[ ${#files_to_organize[@]} -eq 0 ]]; then
    verbose_log "No files found to organize (older than $DAYS_OLD days)"
    exit 0
fi

log "Found ${#files_to_organize[@]} files to organize"

declare -A monthly_folders
declare -A folder_file_counts

for file in "${files_to_organize[@]}"; do
    monthly_folder=$(get_monthly_folder "$file")
    monthly_folders["$monthly_folder"]=1
    folder_file_counts["$monthly_folder"]=$((${folder_file_counts["$monthly_folder"]:-0} + 1))
    
    if [[ "$VERBOSE" == "true" ]]; then
        file_date=$(ls -l "$file" | awk '{print $6, $7, $8}')
        verbose_log "  $(basename "$file") -> $(basename "$monthly_folder")/ (modified: $file_date)"
    fi
done

if [[ "$VERBOSE" == "true" ]]; then
    log "Monthly folders to be created/used:"
    for folder in "${!monthly_folders[@]}"; do
        log "  $(basename "$folder")/ (${folder_file_counts["$folder"]} files)"
    done
fi

if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY RUN: Would organize ${#files_to_organize[@]} files into ${#monthly_folders[@]} monthly folders"
    exit 0
fi

for folder in "${!monthly_folders[@]}"; do
    if [[ ! -d "$folder" ]]; then
        if mkdir -p "$folder"; then
            verbose_log "Created directory: $(basename "$folder")/"
        else
            log "Failed to create directory: $folder"
            continue
        fi
    fi
done

moved_count=0

for file in "${files_to_organize[@]}"; do
    
    if [[ ! -f "$file" ]]; then
        verbose_log "File no longer exists: $file"
        continue
    fi
    
    monthly_folder=$(get_monthly_folder "$file")
    
    if [[ -z "$monthly_folder" ]]; then
        log "ERROR: Failed to determine monthly folder for: $file - stopping script"
        exit 1
    fi
    
    filename=$(basename "$file")
    destination="$monthly_folder/$filename"
    
    if [[ -e "$destination" ]]; then
        log "ERROR: Destination already exists: $filename -> $(basename "$monthly_folder")/ - stopping script"
        exit 1
    fi
    
    if mv "$file" "$destination"; then
        verbose_log "Moved: $filename -> $(basename "$monthly_folder")/"
        moved_count=$((moved_count + 1))
    else
        log "ERROR: Failed to move $filename to $(basename "$monthly_folder")/ - stopping script"
        log "Successfully moved $moved_count out of ${#files_to_organize[@]} files before error"
        exit 1
    fi
done

log "Successfully moved $moved_count files"