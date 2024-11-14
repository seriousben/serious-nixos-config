{
  description = "serious mbp config";
  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
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
  };

  outputs =
    {
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
    in
    {
      darwinConfigurations.serious-mbp = darwin.lib.darwinSystem {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        specialArgs = {
          inherit inputs user pkgs-unstable;
        };
        modules = [
          # Allow unfree packages.
          { nixpkgs.config.allowUnfree = true; }
          nix-homebrew.darwinModules.nix-homebrew
          # https://daiderd.com/nix-darwin/manual/index.html
          ./darwin
          # https://nix-community.github.io/home-manager/options.xhtml
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.${user} = ./home-manager;
              sharedModules = [ ];
            };
          }
        ];
      };
    };
}
