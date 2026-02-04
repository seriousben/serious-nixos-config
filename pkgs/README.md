# Custom Packages

This directory contains custom Nix derivations for packages not available in nixpkgs.

## pi-coding-agent

Terminal coding agent from the pi-mono repository.

### Updating

1. **Update the flake input and package hash (recommended):**
   ```bash
   make update                    # Updates all flake inputs
   make update-pi-coding-agent    # Automatically updates npmDepsHash using nix-update
   make apply                     # Apply the changes
   ```

2. **Manual hash update methods:**

   If automatic update doesn't work, you can manually update the `npmDepsHash`:

   **Method A: Let Nix tell you the hash**
   - Set `npmDepsHash = lib.fakeHash;` in `pkgs/pi-coding-agent.nix`
   - Run `make apply`
   - Copy the correct hash from the error message
   - Update `pkgs/pi-coding-agent.nix` with the correct hash

   **Method B: Use prefetch-npm-deps**
   ```bash
   # First, get the pi-mono source
   nix flake prefetch github:badlogic/pi-mono --json | jq -r .path

   # Then calculate the hash
   nix run nixpkgs#prefetch-npm-deps -- /nix/store/xxx-source/packages/coding-agent/package-lock.json

   # Update the hash in pkgs/pi-coding-agent.nix
   ```

   **Method C: Use nix-update directly**
   ```bash
   nix run nixpkgs#nix-update -- --flake --build pi-coding-agent
   ```

### Testing

Test the package builds correctly:
```bash
nix build .#pi-coding-agent
# Or
nix run .#pi-coding-agent -- --help
```

### Version Management

The package version uses the flake input's last modified date:
```nix
version = "unstable-${builtins.substring 0 8 inputs.pi-mono.lastModifiedDate}";
```

This gives versions like `unstable-20250129`, making it easy to see when the package was last updated.
