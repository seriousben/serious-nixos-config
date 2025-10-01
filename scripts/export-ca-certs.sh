#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="export-ca-certs"
CERTS_DIR="$HOME/.config/certs"
VERBOSE=false

usage() {
    cat << EOF
Usage: CERT_PATTERN="pattern" $0 [OPTIONS]

Export CA certificates from macOS Keychain to ~/.config/certs/

ENVIRONMENT VARIABLES:
    CERT_PATTERN    Pattern to match certificates (required, e.g., "mycert.security")

OPTIONS:
    --verbose       Show detailed output
    --help          Show this help message

EXAMPLES:
    CERT_PATTERN="mycompany" $0
    CERT_PATTERN="mycompany" $0 --verbose
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

verbose_log "Searching for certificates matching pattern: $CERT_PATTERN"

# Find all matching certificates and export them
cert_count=0
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
done < <(security find-certificate -a -c "$CERT_PATTERN" | grep "labl" | sed 's/.*<blob>="\(.*\)"/\1/')

if [[ $cert_count -eq 0 ]]; then
    log "WARNING: No certificates found matching pattern: $CERT_PATTERN"
    exit 1
fi

log "Successfully exported $cert_count certificate(s)"

# Create bundle file for NODE_EXTRA_CA_CERTS
bundle_file="$CERTS_DIR/ca-bundle.pem"
verbose_log "Creating certificate bundle: $bundle_file"

if cat "$CERTS_DIR"/*.pem > "$bundle_file" 2>/dev/null; then
    log "Created certificate bundle: $bundle_file"
else
    log "ERROR: Failed to create certificate bundle"
    exit 1
fi

log "Done. Set NODE_EXTRA_CA_CERTS=$bundle_file in your shell config"
