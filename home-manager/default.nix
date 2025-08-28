{
  config,
  pkgs,
  lib,
  ...
}:
let
  sources = import ../nix/sources.nix;
in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
    stateVersion = "23.11";
  };

  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
  };

  # Instead, manually create the config file
  xdg.configFile."ghostty/config" = {
    text = ''
      command = /etc/profiles/per-user/seriousben/bin/fish
      theme = catppuccin-frappe
      # keybind = alt+v=esc:v
      macos-option-as-alt = true
    '';
  };

  # CLAUDE.md configuration in ~/.claude/
  home.file.".claude/CLAUDE.md" = {
    text = builtins.readFile ./files/AGENT.md;
  };

  # AGENT.md configuration in ~/.config/
  xdg.configFile."AGENT.md" = {
    text = builtins.readFile ./files/AGENT.md;
  };

  # Claude Code sub-agents
  home.file.".claude/agents/architectural-reviewer.md" = {
    text = builtins.readFile ./files/agents/architectural-reviewer.md;
  };

  home.file.".claude/agents/security-focused-reviewer.md" = {
    text = builtins.readFile ./files/agents/security-focused-reviewer.md;
  };

  home.file.".claude/agents/claude-md-curator.md" = {
    text = builtins.readFile ./files/agents/claude-md-curator.md;
  };

  # Claude Code system-level settings
  home.file.".claude/settings.json" = {
    text = builtins.toJSON {
      permissions = {
        allow = [
          "Bash(ls*)"
          "Bash(find*)"
          "Bash(mkdir*)"
          "Bash(go run mage.go*)"
          "Bash(npm test*)"
          "Bash(npm test)"
          "Bash(npm run build*)"
          "Bash(npm run format*)"
          "Bash(npm run lint*)"
          "Bash(gh run list*)"
          "Bash(gh run view*)"
          "Bash(rg*)"
        ];
        deny = [];
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      # from https://github.com/direnv/direnv/issues/592
      layout_poetry() {
        if ! direnv_load poetry run direnv dump; then
          log_error "failed to enter Poetry env, do you need 'poetry install'?"
          return 2
        fi
      }
    '';
  };

  programs.fish = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/tree/7eee17a8a5868ecf596bbb8c8beb527253ea8f4d/pkgs/shells/fish/plugins
    plugins =
      map
        (n: {
          name = n;
          src = sources.${n};
        })
        [
          "z"
          "theme-bobthefish"
        ];

    interactiveShellInit = lib.strings.concatStrings (
      lib.strings.intersperse "\n" [
        (builtins.readFile ./files/config.fish)
        "set -g SHELL ${pkgs.fish}/bin/fish"
      ]
    );

    functions = {
      command_stress_test = {
        body = (builtins.readFile ./files/command_stress_test.fish);
        description = "Stress test a command by running it multiple times.";
        # arguments
      };
    };

    shellAliases = {
      mage = "go run mage.go --";
    };

    # FIXME: This is needed to address bug where the $PATH is re-ordered by
    # the `path_helper` tool, prioritising Apple’s tools over the ones we’ve
    # installed with nix.
    #
    # This gist explains the issue in more detail: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
    # There is also an issue open for nix-darwin: https://github.com/LnL7/nix-darwin/issues/122
    loginShellInit =
      let
        # We should probably use `config.environment.profiles`, as described in
        # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
        # but this takes into account the new XDG paths used when the nix
        # configuration has `use-xdg-base-directories` enabled. See:
        # https://github.com/LnL7/nix-darwin/issues/947 for more information.
        profiles = [
          "/etc/profiles/per-user/$USER" # Home manager packages
          "$HOME/.nix-profile"
          "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
          "/run/current-system/sw"
          "/nix/var/nix/profiles/default"
        ];

        makeBinSearchPath = lib.concatMapStringsSep " " (path: "${path}/bin");
      in
      ''
        # Fix path that was re-ordered by Apple's path_helper
        fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
        set fish_user_paths $fish_user_paths
      '';
  };

  # https://wiki.nixos.org/wiki/Fish
  programs.zsh = {
    enable = true;
    #
    # FIXME: vscode cannot get environment variables with exec fish.
    #        keeping zsh the default and changing terminal to start fish.
    #
    # initExtra = ''
    #   #if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
    #   then
    #       exec fish -l
    #   fi
    # '';
  };

  programs.git = {
    enable = true;
    userName = "Benjamin Boudreau";
    userEmail = "boudreau.benjamin@gmail.com";
    signing = {
      key = "A29A33BE12C39BE2";
      signByDefault = true;
    };
    ignores = lib.strings.intersperse "\n" [
      (builtins.readFile ./files/gitignore)
      "# direnv patterns"
      ".envrc.secrets"
      "# Tensorlake specifics"
      "indexify_local_runner_cache"
      "indexify_storage"
    ];
    aliases = {
      up = "!git remote update -p; git merge --ff-only @{u}; git submodule update --init";
      cleanup = "!git branch --merged | grep  -v '\\*\\|main\\|develop\\|master' | xargs -n 1 -r git branch -d";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
      # We wanna grab those pesky un-added files!
      # https://git-scm.com/docs/git-stash
      stash-all = "stash save --include-untracked";
    };

    extraConfig = {
      user.useConfigOnly = true;
      branch.autoSetupRebase = "always";
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "seriousben";
      push.default = "tracking";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";

      status = {
        submoduleSummary = "true";
        showUntrackedFiles = "all";
      };

      url = {
        "git@github.com:" = {
          pushInsteadOf = "https://github.com/";
          insteadOf = "https://github.com/";
        };
      };
    };
  };

  programs.pyenv = {
    enable = true;
  };

  #programs.poetry = {
  #  enable = true;
  #};

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    extraConfig = "
      set clipboard=unnamedplus
      colorscheme dracula

      \" Highlight trailing whitespace
      highlight ExtraWhitespace ctermbg=red guibg=#FF4444
      match ExtraWhitespace /\\s\\+$/

      \" Auto-remove trailing whitespace on save
      autocmd BufWritePre * :%s/\\s\\+$//e
    ";
    plugins = with pkgs; [
      vimPlugins.dracula-nvim
      vimPlugins.nvim-lastplace
    ];
  };

  launchd = {
    enable = true;
    agents = {
      # Delete screenshots older than 30 days using our custom script.
      gc_screenshots = {
        enable = true;
        config = {
          Program = "${pkgs.bash}/bin/bash";
          ProgramArguments = [
            "${pkgs.bash}/bin/bash"
            "${config.home.homeDirectory}/src/seriousben/serious-nixos-config/scripts/cleanup-screenshots.sh"
            "--verbose"
          ];
          RunAtLoad = false;
          KeepAlive = false;
          startInterval = 2678400; # 31 days.
          # debugging
          # StartInterval = 10;
          StandardErrorPath = "${config.home.homeDirectory}/gc_screenshot-stderr.log";
          StandardOutPath = "${config.home.homeDirectory}/gc_screenshot-stdout.log";
        };
      };

      # Organize downloads into monthly folders.
      organize_downloads = {
        enable = true;
        config = {
          Program = "${pkgs.bash}/bin/bash";
          ProgramArguments = [
            "${pkgs.bash}/bin/bash"
            "${config.home.homeDirectory}/src/seriousben/serious-nixos-config/scripts/organize-downloads.sh"
            "--verbose"
          ];
          RunAtLoad = false;
          KeepAlive = false;
          startInterval = 604800; # 7 days (weekly).
          # debugging
          # StartInterval = 10;
          StandardErrorPath = "${config.home.homeDirectory}/organize_downloads-stderr.log";
          StandardOutPath = "${config.home.homeDirectory}/organize_downloads-stdout.log";
        };
      };
    };
  };
}
