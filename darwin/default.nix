{
  pkgs,
  pkgs-unstable,
  inputs,
  user,
  ...
}:
let
  # LLM/AI CLI tools from numtide/llm-agents.nix (daily updates, binary cache)
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages =
    (with pkgs; [
      vim

      # gnu all the things
      coreutils
      gnused
      gnugrep
      findutils
      moreutils

      # git
      git
      openssh
      gnupg

      # nix development
      nixd
      nixfmt-rfc-style

      # development
      direnv
      _1password-cli
      awscli2
      cmake
      # ngrok

      # general utils
      ripgrep
      jq
      wget
      curl
      yq-go
      envsubst
      mysides

      # rust
      rustup

      # node
      nodejs_22
      pnpm

      # python
      pipx
      uv

    ])
    ++ [
      # LLM/AI CLI tools from numtide/llm-agents.nix
      llmAgents.pi
      llmAgents.claude-code
    ]
    ++ (with pkgs-unstable; [
      postgresql_17
      k6
      terraform

      # go
      go_1_24
    ]);

  nix = {
    enable = false;
  };

  # homebrew
  nix-homebrew = {
    inherit user;
    enable = true;
    taps = {
      "homebrew/core" = inputs.homebrew-core;
      "homebrew/cask" = inputs.homebrew-cask;
      "homebrew/bundle" = inputs.homebrew-bundle;
      "tilt-dev/tap" = inputs.tilt-dev-tap;
      "seriousben/tiltbar" = inputs.tiltbar-tap;
    };
    mutableTaps = true;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;

    # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.onActivation.cleanup
    onActivation = {
      upgrade = true;
      cleanup = "zap";
    };

    # https://daiderd.com/nix-darwin/manual/index.html#opt-homebrew.caskArgs.no_quarantine
    caskArgs.no_quarantine = true;
    global.brewfile = true;

    #masApps = { };

    # Taps are already defined in nix-homebrew.taps above

    brews = [
      "gh"
      "k3d"
      "tilt-dev/tap/tilt"
      "kubernetes-cli"
      "pulumi"
      "seriousben/tiltbar/tiltbar"
    ];
    casks = [
      "1password"
      "discord"
      "firefox@developer-edition"
      "google-chrome@dev"
      "monodraw"
      "alfred"
      "visual-studio-code@insiders"
      "cursor"
      "rectangle"
      "ghostty"
      "tidal"
      "slack"
      "zoom"

      # LLM
      "claude"

      # Work
      "granola"
      "loom"
      "linear-linear"

      # office setup
      "shureplus-motiv"
      "elgato-control-center"

      # docker / k8s
      "orbstack"
    ];
  };
  #services.nix-daemon.enable = true;

  imports = [
    ./system-defaults.nix
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;
  environment.shells = [
    pkgs.zsh
    pkgs.bash
    pkgs.fish
  ];

  # Darwin User setup
  users.users.${user} = {
    home = "/Users/${user}";
    isHidden = false;
  };

}
