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
      awscli2
      cmake
      ngrok

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
    ++ (with pkgs-unstable; [
      postgresql_17
      k6
      terraform

      # go
      go_1_24
    ]);

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
      "ghostty"
      "tidal"
      "slack"
      "zoom"

      # LLM
      "claude"
      "claude-code"

      "granola"
      "loom"

      # Work
      "linear-linear"

      # shure mic
      "shureplus-motiv"

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

  # System activation scripts
  system.activationScripts.postActivation.text = ''
    # Configure sidebar items using mysides
    echo "Configuring Finder sidebar..."

    # Add common folders to sidebar
    /usr/bin/sudo -u "${user}" ${pkgs.mysides}/bin/mysides add "Home" "file:///Users/${user}/" || true
    /usr/bin/sudo -u "${user}" ${pkgs.mysides}/bin/mysides add "Downloads" "file:///Users/${user}/Downloads/" || true
    /usr/bin/sudo -u "${user}" ${pkgs.mysides}/bin/mysides add "Documents" "file:///Users/${user}/Documents/" || true
    /usr/bin/sudo -u "${user}" ${pkgs.mysides}/bin/mysides add "Screenshots" "file:///Users/${user}/Pictures/screenshots/" || true
    /usr/bin/sudo -u "${user}" ${pkgs.mysides}/bin/mysides add "Keycard" "file:///Users/${user}/src/keycard/" || true
    /usr/bin/sudo -u "${user}" ${pkgs.mysides}/bin/mysides add "SeriousBen" "file:///Users/${user}/src/seriousben/" || true
    /usr/bin/sudo -u "${user}" ${pkgs.mysides}/bin/mysides add "Applications" "file:///Applications/" || true

    echo "Finder sidebar configuration complete"
  '';

  fonts = {
    packages = [
      pkgs.nerd-fonts.inconsolata-go
    ];
  };

  # TODO: Disable finder tags, configure favorite folders.
  system = {
    # Sets the state version for the Nix Darwin configuration
    stateVersion = 4;

    # Sets the primary user for the system
    primaryUser = user;

    # System startup settings
    startup = {
      # Disables the startup chime sound
      chime = false;
    };

    # Default system configurations
    defaults = {
      # Custom user preferences settings
      CustomUserPreferences = {
        # System-wide global domain settings
        NSGlobalDomain = {
          # Disables requiring confirmation when closing apps with unsaved changes
          NSCloseAlwaysConfirmsChanges = false;
          # Enables switching to the space an application is in when you activate it
          AppleSpacesSwitchOnActivate = true;
        };

        # Apple Music settings
        "com.apple.Music" = {
          # Disables playback notifications
          userWantsPlaybackNotifications = false;
        };

        # Activity Monitor settings
        "com.apple.ActivityMonitor" = {
          # Sets update frequency to 1 second
          UpdatePeriod = 1;
        };

        # TextEdit settings
        "com.apple.TextEdit" = {
          # Disables smart quotes
          SmartQuotes = false;
          # Uses plain text mode by default instead of rich text
          RichText = false;
        };

        # Spaces settings
        "com.apple.spaces" = {
          # Prevents spaces from spanning across multiple displays
          "spans-displays" = false;
        };

        # Menu bar clock settings
        "com.apple.menuextra.clock" = {
          # Sets the date format for the menu bar
          DateFormat = "EEE d MMM HH:mm:ss";
          # Disables flashing date separators
          FlashDateSeparators = false;
        };

        # Finder settings
        "com.apple.finder" = {
          # Sets home directory as the default folder when opening a new Finder window
          NewWindowTargetPath = "file:///Users/${user}/";
          NewWindowTarget = "PfHm";
          # Sets the default search scope to current folder
          FXDefaultSearchScope = "SCcf";
          # Enables opening files in tabs rather than new windows
          FinderSpawnTab = true;
          # Disables warning when emptying the trash
          WarnOnEmptyTrash = false;
          # Disables the tags feature in Finder
          ShowRecentTags = false;
          # Disables the tags section in the Finder sidebar
          FavoriteTagNames = [ ];
          TagsButtonVisible = false;
          # Configure favorite folders in the sidebar
          FavoriteItems = [
            "file:///Users/${user}/"
            "file:///Users/${user}/Documents/"
            "file:///Users/${user}/Downloads/"
            "file:///Users/${user}/Pictures/screenshots/"
            "file:///Users/${user}/src/keycard/"
            "file:///Users/${user}/src/seriousben/"
            "file:///Applications/"
          ];
          # Don't show volumes on the desktop (for clean desktop)
          ShowExternalHardDrivesOnDesktop = false;
          ShowHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          ShowMountedServersOnDesktop = false;
        };

        # Desktop Services settings
        "com.apple.desktopservices" = {
          # Prevents creating .DS_Store files on network volumes
          DSDontWriteNetworkStores = true;
          # Prevents creating .DS_Store files on USB drives
          DSDontWriteUSBStores = true;
        };

        # Control Center settings (using ByHost preferences)
        # "~/Library/Preferences/ByHost/com.apple.controlcenter" = {
        #   # Shows battery percentage in the menu bar
        #   BatteryShowPercentage = true;
        # };

        # Privacy settings
        "com.apple.AdLib" = {
          # Disables Apple personalized advertising
          allowApplePersonalizedAdvertising = false;
        };

        # Safari settings for web development
        "com.apple.Safari" = {
          # Enables Safari Developer Menu
          IncludeDevelopMenu = true;
          # Enables Web Inspector
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          # Enables developer extras
          WebKitPreferences.developerExtrasEnabled = true;
          # Disable continuous spell checking
          WebContinuousSpellCheckingEnabled = false;
        };

        # Terminal settings for development
        "com.apple.Terminal" = {
          # Use UTF-8 by default
          StringEncodings = 4;
          # Enable secure keyboard entry
          SecureKeyboardEntry = true;
        };

        # Disable Crash Reporter dialogs
        "com.apple.CrashReporter" = {
          # Don't show crash reporter dialogs
          DialogType = "none";
        };
      };

      # Application Layer Firewall settings
      alf = {
        # Allows signed downloaded applications through the firewall
        allowdownloadsignedenabled = 1;
        # Allows signed applications through the firewall
        allowsignedenabled = 1;
        # Sets the firewall to be enabled
        globalstate = 1;
        # Disables firewall logging
        loggingenabled = 0;
        # Enables stealth mode to prevent responses to network discovery attempts
        stealthenabled = 1;
      };

      # Launch Services settings (handles file associations and app launching)
      LaunchServices = {
        # Controls whether to show a warning when opening downloaded applications
        LSQuarantine = false;
      };

      # Screen capture settings
      screencapture = {
        # Sets the default location for saving screenshots
        location = "/Users/${user}/Pictures/screenshots";
        # Disables the shadow effect in screenshots
        disable-shadow = true;
        # Shows a thumbnail preview after taking a screenshot
        show-thumbnail = true;
        # Sets the default screenshot format to PNG
        type = "png";
        # Sets the target to a file (not clipboard)
        target = "file";
      };

      # Dock settings
      dock = {
        # Enables app switcher across all displays
        appswitcher-all-displays = true;
        # Enables automatically hiding the dock
        autohide = true;
        # Sets the delay before the dock appears when hovering
        autohide-delay = 0.2;
        # Sets the animation speed for the dock hiding/showing
        autohide-time-modifier = 0.15;
        # Disables dashboard in overlay mode
        dashboard-in-overlay = false;
        # Disables spring loading for all items
        enable-spring-load-actions-on-all-items = false;
        # Sets the duration for exposé animations
        expose-animation-duration = 0.2;
        # Disables grouping apps in exposé
        expose-group-apps = false;
        # Controls whether to animate opening applications
        launchanim = false;
        # Sets the minimize effect to genie
        mineffect = "genie";
        # Disables minimizing windows to their application icon
        minimize-to-application = false;
        # Enables highlighting items in stacks when hovering
        mouse-over-hilite-stack = true;
        # Disables ordering spaces by most recently used
        mru-spaces = false;
        # Sets the dock orientation to the bottom of the screen
        orientation = "bottom";
        # Shows indicators for running processes
        show-process-indicators = true;
        # Controls whether to show recent applications in the dock
        show-recents = false;
        # Controls whether to show indicators for hidden applications
        showhidden = false;
        # Allows both running and non-running apps in the dock
        static-only = false;
        # Sets the size of dock icons
        tilesize = 48;
        # Sets actions for hot corners (1 = disabled)
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;

        # Lists applications that should always appear in the dock
        persistent-apps = [
          "/Applications/Slack.app/"
          "/Applications/Firefox Developer Edition.app/"
          "/Applications/Google Chrome Dev.app/"
          "/System/Applications/Home.app/"
        ];

        # Commented out from original - a reference to adding Downloads folder
        # persistent-others = [ "${userHome}/Downloads/" ];
      };

      # Finder settings
      finder = {
        # Shows the full POSIX path in the window title
        _FXShowPosixPathInTitle = true;
        # Sorts folders first when listing files
        _FXSortFoldersFirst = true;
        # Shows all file extensions
        AppleShowAllExtensions = true;
        # Shows hidden files
        AppleShowAllFiles = true;
        # Enables the desktop (icons, etc.)
        CreateDesktop = true;
        # Sets the default search scope
        FXDefaultSearchScope = "SCcf";
        # Disables warning when changing file extensions
        FXEnableExtensionChangeWarning = false;
        # Sets the preferred view style (column view)
        FXPreferredViewStyle = "clmv";
        # Disables the Quit menu item for Finder
        QuitMenuItem = false;
        # Shows the path bar in Finder windows
        ShowPathbar = true;
        # Controls whether to show the status bar in Finder windows
        ShowStatusBar = true;
      };

      # Login window settings
      loginwindow = {
        # Disables automatic login (no default user)
        autoLoginUser = null;
        # Allows console access
        DisableConsoleAccess = false;
        # Disables guest account
        GuestEnabled = false;
        # No custom login window text
        LoginwindowText = null;
        # Allows power off while logged in
        PowerOffDisabledWhileLoggedIn = false;
        # Allows restart
        RestartDisabled = false;
        # Allows restart while logged in
        RestartDisabledWhileLoggedIn = false;
        # Shows the login name rather than full name
        SHOWFULLNAME = false;
        # Allows shutdown
        ShutDownDisabled = false;
        # Allows shutdown while logged in
        ShutDownDisabledWhileLoggedIn = false;
        # Allows sleep
        SleepDisabled = false;
      };

      # Magic Mouse settings
      magicmouse = {
        # Enables right-click (secondary click)
        MouseButtonMode = "TwoButton";
      };

      # SMB (Samba) settings
      smb = {
        # No custom NetBIOS name
        NetBIOSName = null;
        # No custom server description
        ServerDescription = null;
      };

      # Spaces settings
      spaces = {
        # Prevents spaces from spanning across multiple displays
        spans-displays = false;
      };

      # Trackpad settings
      trackpad = {
        # Sets the actuation strength
        ActuationStrength = 1;
        # Enables tap to click
        Clicking = true;
        # Enables click and drag without having to hold down
        Dragging = true;
        # Sets threshold for first click
        FirstClickThreshold = 1;
        # Sets threshold for second click
        SecondClickThreshold = 2;
        # Enables right-click (secondary click)
        TrackpadRightClick = true;
        # Enables three-finger drag
        TrackpadThreeFingerDrag = true;
        # Disables three-finger tap gesture
        TrackpadThreeFingerTapGesture = 0;
      };

      # Universal Access settings (accessibility)
      universalaccess = {
        # Disables zoom with scroll wheel
        closeViewScrollWheelToggle = false;
        # Disables zoom following focus
        closeViewZoomFollowsFocus = false;
        # Disables transparency reduction
        reduceTransparency = false;
        # Sets cursor size to default
        mouseDriverCursorSize = 1.0;
      };

      # Software Update settings
      SoftwareUpdate = {
        # Enables automatic macOS updates
        AutomaticallyInstallMacOSUpdates = true;
      };

      # Window Manager settings (like Stage Manager)
      WindowManager = {
        # Controls window grouping behavior
        AppWindowGroupingBehavior = true;
        # Disables auto-hide
        AutoHide = false;
        # Disables standard click to show desktop
        EnableStandardClickToShowDesktop = false;
        # Disables tiled window margins
        EnableTiledWindowMargins = false;
        # Disables globally
        GloballyEnabled = false;
        # Shows desktop
        HideDesktop = false;
        # Controls whether Stage Manager hides widgets
        StageManagerHideWidgets = false;
        # Controls whether to hide desktop icons by default
        StandardHideDesktopIcons = false;
        # Controls whether to hide widgets by default
        StandardHideWidgets = false;
      };

      # Global preferences (not domain-specific)
      ".GlobalPreferences" = {
        # No custom mouse scaling
        "com.apple.mouse.scaling" = null;
        # No custom beep sound
        "com.apple.sound.beep.sound" = null;
      };

      # NSGlobalDomain settings (system-wide preferences)
      NSGlobalDomain = {
        # Shows the menu bar
        _HIHideMenuBar = false;
        # Disables function key mode by default
        "com.apple.keyboard.fnState" = false;
        # Enables tap to click (1 = enabled)
        "com.apple.mouse.tapBehavior" = 1;
        # Disables feedback when adjusting volume
        "com.apple.sound.beep.feedback" = 0;
        # Mutes system beep
        "com.apple.sound.beep.volume" = 0.0;
        # Sets delay for spring-loaded folders/windows
        "com.apple.springing.delay" = 1.0;
        # No override for spring-loaded folders/windows
        "com.apple.springing.enabled" = null;
        # Enables "natural" scroll direction
        "com.apple.swipescrolldirection" = true;
        # Enables secondary click on trackpad
        "com.apple.trackpad.enableSecondaryClick" = true;
        # Disables force click
        "com.apple.trackpad.forceClick" = false;
        # No custom trackpad scaling
        "com.apple.trackpad.scaling" = null;
        # No custom trackpad corner click behavior
        "com.apple.trackpad.trackpadCornerClickBehavior" = null;
        # Enables mouse swipe navigation
        AppleEnableMouseSwipeNavigateWithScrolls = true;
        # Enables swipe navigation
        AppleEnableSwipeNavigateWithScrolls = true;
        # No custom font smoothing
        AppleFontSmoothing = null;
        # Forces 24-hour time format
        AppleICUForce24HourTime = true;
        # Sets dark mode
        AppleInterfaceStyle = "Dark";
        # Disables automatic switching between light/dark mode
        AppleInterfaceStyleSwitchesAutomatically = false;
        # No custom keyboard UI mode
        AppleKeyboardUIMode = null;
        # Sets measurement units to centimeters
        AppleMeasurementUnits = "Centimeters";
        # Uses metric units
        AppleMetricUnits = 1;
        # Disables press and hold for special characters
        ApplePressAndHoldEnabled = false;
        # Enables page-by-page scrolling
        AppleScrollerPagingBehavior = true;
        # Shows all file extensions
        AppleShowAllExtensions = true;
        # Shows hidden files
        AppleShowAllFiles = true;
        # Always shows scroll bars instead of only when scrolling
        AppleShowScrollBars = "Always";
        # Enables switching to an app's space when activating it
        AppleSpacesSwitchOnActivate = true;
        # Sets temperature unit to Celsius
        AppleTemperatureUnit = "Celsius";
        # Always uses tabs for windows
        AppleWindowTabbingMode = "always";
        # Sets initial key repeat delay (lower is faster)
        InitialKeyRepeat = 15; # slider values: 120, 94, 68, 35, 25, 15
        # Sets key repeat rate (lower is faster)
        KeyRepeat = 2; # slider values: 120, 90, 60, 30, 12, 6, 2
        # Disables automatic capitalization
        NSAutomaticCapitalizationEnabled = false;
        # Disables automatic dash substitution
        NSAutomaticDashSubstitutionEnabled = false;
        # Disables automatic period substitution
        NSAutomaticPeriodSubstitutionEnabled = false;
        # Disables automatic quote substitution
        NSAutomaticQuoteSubstitutionEnabled = false;
        # Disables automatic spelling correction
        NSAutomaticSpellingCorrectionEnabled = false;
        # Enables window animations
        NSAutomaticWindowAnimationsEnabled = true;
        # No override for automatic termination
        NSDisableAutomaticTermination = null;
        # Disables saving new documents to iCloud by default
        NSDocumentSaveNewDocumentsToCloud = false;
        # Expands save panel by default
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        # Enables scroll animations
        NSScrollAnimationEnabled = true;
        # Sets table view size mode
        NSTableViewDefaultSizeMode = 2;
        # Shows control characters (useful for developers)
        NSTextShowsControlCharacters = true;
        # Enables animated focus ring
        NSUseAnimatedFocusRing = true;
        # Sets window resize time
        NSWindowResizeTime = 2.0e-2;
        # Expands print panel by default
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
    };

    # Keyboard settings
    keyboard = {
      # Enables key mapping
      enableKeyMapping = true;
      # Commented out: Does not remap Caps Lock to Control
      # remapCapsLockToControl = true;
    };
  };
}
