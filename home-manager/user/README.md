# Portable User Home-Manager Module

This directory contains portable user configuration that works on both **Linux** and **macOS**.

## Structure

```
user/
├── default.nix          # Main portable user config module
├── files/
│   ├── config/          # Shell, git, editor configs
│   │   ├── config.fish
│   │   ├── gitignore
│   │   ├── git-hooks/
│   │   └── gitleaks/
│   └── agents/          # AI agent configs (grouped for future extraction)
│       ├── claude/
│       ├── pi/
│       └── skills/
└── README.md            # This file
```

## What's Included (Portable)

- **Shell**: Fish with bobthefish theme, z plugin, custom functions
- **Git**: Global gitconfig, ignores, hooks, gitleaks config
- **Editors**: Neovim with dracula theme
- **Tools**: direnv, pyenv
- **Database**: psql configuration
- **Agents**: Claude, Pi, and skill configurations

## Options

All options live under `seriousben.user` and default to `true` for backward compatibility with the macOS config.

| Option | Default | Description |
|--------|---------|-------------|
| `useSymlinks` | `true` | Use out-of-store symlinks to the local repo checkout. Set `false` on remote machines to copy files into the Nix store instead. |
| `git.gpgSign` | `true` | Enable GPG commit signing. When `false`, `signing.signByDefault` and `signing.key` are omitted. |
| `git.sshRewrite` | `true` | Rewrite GitHub HTTPS URLs to SSH. When `false`, the `url."git@github.com:"` block is omitted. |
| `nix.includeAccessTokens` | `true` | Include `nix-access-tokens.conf` in nix.conf. When `false`, the `!include` line is omitted. |
| `agents.enable` | `true` | Install Claude and Pi agent config files. When `false`, all agent file placements are skipped. |

## macOS-Specific Additions

The parent `home-manager/default.nix` adds:
- `launchd` agents (screenshot cleanup, download organizer)

## Usage on VPS (Linux)

The user module requires these flake inputs:
- `theme-bobthefish` - Fish shell theme
- `fish-z` - Fish directory jumping plugin  
- `skills-curated` - Pi agent skills

### Option 1: Define Inputs Explicitly (VPS controls versions)

```nix
{
  inputs.serious-config.url = "github:seriousben/serious-nixos-config";
  inputs.home-manager.url = "github:nix-community/home-manager/release-25.11";
  
  # Define your own versions
  inputs.theme-bobthefish.url = "github:oh-my-fish/theme-bobthefish";
  inputs.theme-bobthefish.flake = false;
  inputs.fish-z.url = "github:jethrokuan/z";
  inputs.fish-z.flake = false;
  inputs.skills-curated.url = "github:trailofbits/skills-curated";
  inputs.skills-curated.flake = false;

  outputs = { self, nixpkgs, home-manager, serious-config, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.seriousben = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          serious-config.homeModules.user
          {
            home = {
              username = "seriousben";
              homeDirectory = "/home/seriousben";
              stateVersion = "23.11";
            };
            # VPS overrides: no symlinks, no GPG, no SSH rewrite, no tokens
            seriousben.user = {
              useSymlinks = false;
              git.gpgSign = false;
              git.sshRewrite = false;
              nix.includeAccessTokens = false;
              agents.enable = false;
            };
          }
        ];
      };
    };
}
```

### Option 2: Use `follows` (Simpler, consistent versions)

```nix
{
  inputs.serious-config.url = "github:seriousben/serious-nixos-config";
  inputs.home-manager.url = "github:nix-community/home-manager/release-25.11";
  
  # Use versions locked in serious-config
  inputs.theme-bobthefish.follows = "serious-config/theme-bobthefish";
  inputs.fish-z.follows = "serious-config/fish-z";
  inputs.skills-curated.follows = "serious-config/skills-curated";

  outputs = { self, nixpkgs, home-manager, serious-config, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.seriousben = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          serious-config.homeModules.user
          {
            home = {
              username = "seriousben";
              homeDirectory = "/home/seriousben";
              stateVersion = "23.11";
            };
            # VPS overrides: no symlinks, no GPG, no SSH rewrite, no tokens
            seriousben.user = {
              useSymlinks = false;
              git.gpgSign = false;
              git.sshRewrite = false;
              nix.includeAccessTokens = false;
              agents.enable = false;
            };
          }
        ];
      };
    };
}
```

**Note**: The module requires `inputs` to be passed via `extraSpecialArgs` for fish plugins and skills.

## Usage on macOS (already configured)

For macOS, use the full module at `home-manager/default.nix` which includes the portable config plus macOS-specific additions.

## Future: Agent Config Extraction

The `files/agents/` directory is structured to be easily moved to a separate repository:

```
seriousben-agent-config/
├── flake.nix
├── claude/
├── pi/
└── skills/
```

When ready, the agent configs can be extracted without changing the user module structure.
