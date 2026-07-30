#!/usr/bin/env bash
# Warns when a newer stable NixOS release branch is available than the one
# pinned in flake.nix.
#
# Usage: ./scripts/check-nixpkgs-release.sh
#
# Reads the pinned `nixos-XX.YY` ref from flake.nix, lists the remote
# `nixos-*` branches on nixpkgs, and prints a warning if a higher release
# exists. Always exits 0 so it never blocks `make update`.

set -euo pipefail

FLAKE_NIX="$(dirname "$0")/../flake.nix"

# Extract the pinned release, e.g. "26.05" from nixos-26.05.
current="$(grep -oE 'nixos-[0-9]{2}\.[0-9]{2}' "$FLAKE_NIX" | head -1 | sed 's/nixos-//')"
if [ -z "$current" ]; then
  echo "warning: could not determine pinned nixpkgs release from flake.nix" >&2
  exit 0
fi

# List remote stable release branches (nixos-YY.05 / nixos-YY.11).
latest="$(git ls-remote --heads https://github.com/nixos/nixpkgs 'nixos-*' 2>/dev/null \
  | grep -oE 'nixos-[0-9]{2}\.[0-9]{2}$' \
  | sed 's/nixos-//' \
  | sort -V \
  | tail -1)"
if [ -z "$latest" ]; then
  echo "warning: could not reach nixpkgs to check for newer releases" >&2
  exit 0
fi

# Compare as versions: if latest sorts after current, a newer release exists.
if [ "$latest" != "$current" ] && [ "$(printf '%s\n%s\n' "$current" "$latest" | sort -V | tail -1)" = "$latest" ]; then
  echo ""
  echo "⚠️  A newer NixOS release is available: $latest (pinned: $current)"
  echo "   Update the nixos-/release-/nix-darwin- refs in flake.nix, then run 'make update'."
  echo ""
fi

exit 0
