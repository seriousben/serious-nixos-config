#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="export-ca-certs"
CERTS_DIR="$HOME/.config/certs"
VERBOSE=false

usage() {
    cat << EOF
Usage: CERT_PATTERN="pattern1,pattern2" $0 [OPTIONS]

Export CA certificates from macOS Keychain to ~/.config/certs/

ENVIRONMENT VARIABLES:
    CERT_PATTERN    Pattern(s) to match certificates (required)
                    Can be a single pattern or comma-separated patterns
                    e.g., "mycert.security" or "cert1,cert2.security"

OPTIONS:
    --verbose       Show detailed output
    --help          Show this help message

EXAMPLES:
    CERT_PATTERN="mycompany" $0
    CERT_PATTERN="mycompany,othercert.security" $0 --verbose
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

if [[ -z "${CERT_PATTERN:-}" ]]; then
    log "ERROR: CERT_PATTERN environment variable is required"
    usage >&2
    exit 1
fi

verbose_log "Creating certs directory: $CERTS_DIR"
mkdir -p "$CERTS_DIR"

# Split comma-separated patterns into array
IFS=',' read -ra PATTERNS <<< "$CERT_PATTERN"

verbose_log "Searching for certificates matching patterns: ${PATTERNS[*]}"

# Find all matching certificates and export them
cert_count=0
for pattern in "${PATTERNS[@]}"; do
    # Trim whitespace from pattern
    pattern=$(echo "$pattern" | xargs)

    if [[ -z "$pattern" ]]; then
        continue
    fi

    verbose_log "Processing pattern: $pattern"

    while IFS= read -r cert_name; do
        if [[ -z "$cert_name" ]]; then
            continue
        fi

        # Sanitize filename: remove special characters, replace spaces with underscores
        safe_filename=$(echo "$cert_name" | tr ' /' '__' | tr -cd '[:alnum:]_-')
        output_file="$CERTS_DIR/${safe_filename}.pem"

        verbose_log "Exporting certificate: $cert_name -> $output_file"

        if security find-certificate -c "$cert_name" -p > "$output_file" 2>/dev/null; then
            log "Exported: $cert_name -> $output_file"
            cert_count=$((cert_count + 1))
        else
            log "WARNING: Failed to export certificate: $cert_name"
        fi
    done < <(security find-certificate -a -c "$pattern" | grep "labl" | sed 's/.*<blob>="\(.*\)"/\1/')
done

if [[ $cert_count -eq 0 ]]; then
    log "WARNING: No certificates found matching patterns: ${PATTERNS[*]}"
    exit 1
fi

log "Successfully exported $cert_count certificate(s)"

# Create bundle file for NODE_EXTRA_CA_CERTS
bundle_file="$CERTS_DIR/ca-bundle.pem"
verbose_log "Creating certificate bundle: $bundle_file"

# Collect all exported cert files (excluding the bundle itself if it exists)
shopt -s extglob nullglob
cert_files=("$CERTS_DIR"/!(ca-bundle).pem)

# Start with system certificates if available, then append exported certs
system_certs="/etc/ssl/certs/ca-certificates.crt"
if [[ -f "$system_certs" ]]; then
    verbose_log "Prepending system certificates from: $system_certs"
    if cat "$system_certs" "${cert_files[@]}" > "$bundle_file" 2>/dev/null; then
        log "Created certificate bundle: $bundle_file"
    else
        log "ERROR: Failed to create certificate bundle"
        exit 1
    fi
else
    verbose_log "System certificates not found at $system_certs, using exported certs only"
    if cat "${cert_files[@]}" > "$bundle_file" 2>/dev/null; then
        log "Created certificate bundle: $bundle_file"
    else
        log "ERROR: Failed to create certificate bundle"
        exit 1
    fi
fi

log "Done. Set NODE_EXTRA_CA_CERTS=$bundle_file in your shell config"
