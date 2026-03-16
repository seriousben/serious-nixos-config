#!/usr/bin/env bash
# Creates ~/.config/nix/nix-access-tokens.conf with a GitHub PAT
# from 1Password, used by Nix to fetch private GitHub flake inputs.
#
# Usage: ./scripts/setup-nix-github-token.sh
#
# Prerequisites: 1Password CLI (op) must be signed in.

set -euo pipefail

CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nix"
CONF_FILE="$CONF_DIR/nix-access-tokens.conf"

# 1Password item reference — same token used by VPS (sync-secrets.sh)
OP_REF="op://cli_secrets/read_github_token/password"

echo "Fetching GitHub token from 1Password..."
TOKEN=$(op read "$OP_REF")

if [ -z "$TOKEN" ]; then
  echo "Error: failed to read token from 1Password" >&2
  exit 1
fi

mkdir -p "$CONF_DIR"
cat > "$CONF_FILE" <<EOF
access-tokens = github.com=$TOKEN
EOF
chmod 600 "$CONF_FILE"

echo "Written: $CONF_FILE"
