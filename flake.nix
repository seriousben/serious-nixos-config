{
  description = "serious nix config - user dotfiles and macOS system config";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    tilt-dev-tap = {
      url = "github:tilt-dev/homebrew-tap";
      flake = false;
    };
    tiltbar-tap = {
      url = "github:seriousben/homebrew-tiltbar";
      flake = false;
    };
    stainless-api-tap = {
      url = "github:stainless-api/homebrew-tap";
      flake = false;
    };
    keycard-tap = {
      url = "github:keycardai/homebrew-tap";
      flake = false;
    };


    # Fish shell plugins
    theme-bobthefish = {
      url = "github:oh-my-fish/theme-bobthefish";
      flake = false;
    };
    fish-z = {
      url = "github:jethrokuan/z";
      flake = false;
    };

    # LLM/AI CLI tools
    llm-agents.url = "github:numtide/llm-agents.nix";

    # Agent skills
    skills-curated = {
      url = "github:trailofbits/skills-curated";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      darwin,
      nix-homebrew,
      ...
    }@inputs:
    let
      user = "seriousben";
      system = "aarch64-darwin";
      pkgs-unstable = import nixpkgs-unstable {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # Workaround for aarch64-darwin codesigning bug (nixpkgs#208951 / #507531):
        # fish binaries from the binary cache occasionally have invalid ad-hoc
        # signatures on Apple Silicon. Forcing a local rebuild ensures codesigning
        # is applied on this machine with a valid signature.
        overlays = [
          (_final: prev: {
            fish = prev.fish.overrideAttrs (_old: {
              NIX_FORCE_LOCAL_REBUILD = "darwin-codesign-fix";
            });
          })
        ];
      };
    in
    {
      # macOS system configuration
      darwinConfigurations.seriousben-mbp = darwin.lib.darwinSystem {
        inherit pkgs;
        specialArgs = {
          inherit inputs user pkgs-unstable;
        };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          ./darwin
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.${user} = ./home-manager;
            };
          }
        ];
      };

      # Reusable home-manager modules
      # Usage:
      #   imports = [ serious-nixos-config.homeModules.user ];
      #   extraSpecialArgs = { inherit inputs; };
      homeModules = {
        user = ./home-manager/user;
        darwinUser = ./home-manager;
      };

      # Also expose as nixosModules for consistency
      nixosModules.user = self.homeModules.user;
    };
}
