{
  pkgs,
  pkgs-unstable,
  inputs,
  user,
  ...
}:
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
    niv # https://github.com/nmattia/niv

    # development
    direnv
    _1password-cli
    awscli
    cmake
    ngrok

    # general utils
    ripgrep
    jq
    wget
    curl

    # rust
    rustup

    # node
    nodejs_22
    pnpm

    # python
    pipx
  ])
  ++
  (with pkgs-unstable; [
    postgresql_17
    k6
    terraform
  ])
  ;

  nix = {
    enable = false;
    #settings = {
      #trusted-users = [
        #"root"
        #user
      #];
      #experimental-features = "nix-command flakes";
      #substituters = [ ];
      #trusted-public-keys = [ ];
      #keep-outputs = true;
      #keep-derivations = true;
    #};
#
    #gc = {
      #user = "root";
      #automatic = true;
      #interval = {
        #Weekday = 0;
        #Hour = 2;
        #Minute = 0;
      #};
      #options = "--delete-older-than 30d";
    #};
#
    ## Turn this on to make command line easier
    #extraOptions = ''
      #experimental-features = nix-command flakes
    #'';
  };

  # homebrew
  nix-homebrew = {
    inherit user;
    enable = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
    mutableTaps = false;
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

    taps = [
      "homebrew/homebrew-core"
      "homebrew/homebrew-cask"
      "homebrew/homebrew-bundle"
    ];

    brews = [
    ];
    casks = [
      "1password"
      "discord"
      "firefox@developer-edition"
      "google-chrome@dev"
      "monodraw"
      "alfred"
      "visual-studio-code@insiders"
      "rectangle"
      "iterm2"
      "ghostty"
      "tidal"
      "slack"
      "zoom"

      # docker / k8s
      "orbstack"
    ];
  };
  #services.nix-daemon.enable = true;

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

  fonts = {
    packages = [ (pkgs.nerdfonts.override { fonts = [ "InconsolataGo" ]; }) ];
  };

  # TODO: Disable finder tags, configure favorite folders.
  system = {
    stateVersion = 4;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      # defaults read com.apple.screencapture
      screencapture = {
        location = "/Users/${user}/Pictures/screenshots";
      };

      # defaults read NSGlobalDomain
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.trackpad.enableSecondaryClick" = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        autohide-delay = 0.2;
        show-recents = false;
        showhidden = false;
        launchanim = false;
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        AppleShowAllExtensions = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };

      magicmouse = {
        MouseButtonMode = "TwoButton";
      };

      CustomUserPreferences = {
        # Settings of plist in ~/Library/Preferences/
        "com.apple.finder" = {
          # Set home directory as startup window
          NewWindowTargetPath = "file:///Users/${user}/";
          NewWindowTarget = "PfHm";
          # Set search scope to directory
          FXDefaultSearchScope = "SCcf";
          # Multi-file tab view
          FinderSpawnTab = true;
        };
        "com.apple.desktopservices" = {
          # Disable creating .DS_Store files in network an USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        # Show battery percentage
        "~/Library/Preferences/ByHost/com.apple.controlcenter".BatteryShowPercentage = true;
        # Privacy
        "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      # remapCapsLockToControl = true;
    };
  };
}
