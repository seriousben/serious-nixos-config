{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.seriousben.user;

  repoPath = "${config.home.homeDirectory}/src/seriousben/serious-nixos-config";

  # Build git hooks directory in the nix store (read-only)
  gitHooksDir = pkgs.runCommand "git-hooks" {} ''
    mkdir -p $out
    cp ${./files/config/git-hooks/pre-commit} $out/pre-commit
    chmod +x $out/pre-commit
  '';

  # Helper: pick symlink or store copy based on useSymlinks
  mkFileSource = storePath: repoRelPath:
    if cfg.useSymlinks
    then config.lib.file.mkOutOfStoreSymlink "${repoPath}/${repoRelPath}"
    else storePath;
in
{
  options.seriousben.user = {
    useSymlinks = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Use out-of-store symlinks pointing at the local repo checkout.
        Set to false on remote/VPS machines to copy files into the Nix store instead.
      '';
    };

    git = {
      gpgSign = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable GPG commit signing. When false, signing.signByDefault
          and signing.key are omitted.
        '';
      };

      sshRewrite = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Rewrite GitHub HTTPS URLs to SSH. When false, the
          url."git@github.com:".insteadOf block is omitted so
          HTTPS works without SSH keys.
        '';
      };
    };

    nix = {
      includeAccessTokens = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Include nix-access-tokens.conf in nix.conf. When false,
          the !include line is omitted to avoid errors when the
          file does not exist.
        '';
      };
    };

    agents = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Install Pi agent configuration files.
          Disable on machines that don't need agent configs.
        '';
      };
    };
  };

  config = lib.mkMerge [
    # ── Core (always applied) ──────────────────────────────────────────
    {
      home = {
        enableNixpkgsReleaseCheck = false;
        sessionVariables = {
          LANG = "en_US.UTF-8";
          LC_CTYPE = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
          SERIOUS_NIXOS_CONFIG_PATH = repoPath;
        };
        stateVersion = "23.11";
      };

      xdg = {
        enable = true;
        cacheHome = "${config.home.homeDirectory}/.cache";
        configHome = "${config.home.homeDirectory}/.config";
      };

      # Gitleaks global config
      xdg.configFile."gitleaks/.gitleaks.toml".source = ./files/config/gitleaks/.gitleaks.toml;

      # Global git hooks (read-only in nix store)
      xdg.configFile."git/hooks".source = gitHooksDir;

      # Ghostty config - only on macOS
      xdg.configFile."ghostty/config" = lib.mkIf pkgs.stdenv.isDarwin {
        text = ''
          command = /etc/profiles/per-user/${config.home.username}/bin/fish
          theme = Catppuccin Frappe
          macos-option-as-alt = true
        '';
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        stdlib = ''
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
        plugins = [
          {
            name = "z";
            src = inputs.fish-z;
          }
          {
            name = "theme-bobthefish";
            src = inputs.theme-bobthefish;
          }
        ];

        interactiveShellInit = lib.strings.concatStrings (
          lib.strings.intersperse "\n" [
            (builtins.readFile ./files/config/config.fish)
            "set -g SHELL ${pkgs.fish}/bin/fish"
          ]
        );

        functions = {
          command_stress_test = {
            body = (builtins.readFile ./files/config/command_stress_test.fish);
            description = "Stress test a command by running it multiple times.";
          };
        };

        shellAliases = {
          mage = "go run mage.go --";
        };

        # macOS-specific: Fix PATH re-ordered by path_helper
        loginShellInit = lib.mkIf pkgs.stdenv.isDarwin (
          let
            profiles = [
              "/etc/profiles/per-user/$USER"
              "$HOME/.nix-profile"
              "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
              "/run/current-system/sw"
              "/nix/var/nix/profiles/default"
            ];
            makeBinSearchPath = lib.concatMapStringsSep " " (path: "${path}/bin");
          in
          ''
            fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
            set fish_user_paths $fish_user_paths
          ''
        );
      };

      programs.zsh = {
        enable = true;
      };

      programs.git = {
        enable = true;
        ignores = lib.strings.intersperse "\n" [
          (builtins.readFile ./files/config/gitignore)
          "# direnv patterns"
          ".envrc.secrets"
          "# Tensorlake specifics"
          "indexify_local_runner_cache"
          "indexify_storage"
        ];

        settings = {
          user = {
            name = "Benjamin Boudreau";
            email = "boudreau.benjamin@gmail.com";
            useConfigOnly = true;
          };
          alias = {
            up = "!git remote update -p; git merge --ff-only @{u}; git submodule update --init";
            cleanup = "!git branch --merged | grep  -v '\\*\\|main\\|develop\\|master' | xargs -n 1 -r git branch -d";
            prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
            root = "rev-parse --show-toplevel";
            stash-all = "stash save --include-untracked";
          };
          branch.autoSetupRebase = "always";
          core.askPass = "";
          core.hooksPath = "${gitHooksDir}";
          credential.helper = "store";
          github.user = "seriousben";
          push.default = "tracking";
          push.autoSetupRemote = true;
          init.defaultBranch = "main";
          status = {
            submoduleSummary = "true";
            showUntrackedFiles = "all";
          };
        };
      };

      programs.pyenv = {
        enable = true;
      };

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

      home.file.".psqlrc" = {
        text = ''
          \set HISTCONTROL ignoredups
          \timing on
          \pset null '∅'
          \pset linestyle unicode
          \pset border 2
          \setenv PAGER 'less -S'
        '';
      };
    }

    # ── Nix access tokens ──────────────────────────────────────────────
    (lib.mkIf cfg.nix.includeAccessTokens {
      xdg.configFile."nix/nix.conf".text = ''
        !include nix-access-tokens.conf
      '';
    })

    # ── GPG signing ────────────────────────────────────────────────────
    (lib.mkIf cfg.git.gpgSign {
      programs.git.signing = {
        key = "A29A33BE12C39BE2";
        signByDefault = true;
      };
    })

    # ── SSH URL rewrite ────────────────────────────────────────────────
    (lib.mkIf cfg.git.sshRewrite {
      programs.git.settings.url = {
        "git@github.com:" = {
          pushInsteadOf = "https://github.com/";
          insteadOf = "https://github.com/";
        };
      };
    })

    # ── Agent configs ──────────────────────────────────────────────────
    (lib.mkIf cfg.agents.enable {
      home.file.".pi/agent/AGENTS.md".source =
        mkFileSource ./files/agents/pi/AGENTS.md "home-manager/user/files/agents/pi/AGENTS.md";
      home.file.".pi/agent/settings.json".source =
        mkFileSource ./files/agents/pi/settings.json "home-manager/user/files/agents/pi/settings.json";
      home.file.".pi/agent/extensions".source =
        mkFileSource ./files/agents/pi/extensions "home-manager/user/files/agents/pi/extensions";
      home.file.".pi/agent/agents".source = ./files/agents/pi/agents;
      home.file.".pi/agent/skills".source = ./files/agents/pi/skills;
    })
  ];
}
