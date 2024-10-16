{
  config,
  pkgs,
  lib,
  ...
}:
let
  sources = import ../../nix/sources.nix;
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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
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
    ];
    aliases = {
      up = "!git remote update -p; git merge --ff-only @{u}; git submodule update --init";
      cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
      # We wanna grab those pesky un-added files!
      # https://git-scm.com/docs/git-stash
      stash-all = "stash save --include-untracked";
    };

    extraConfig = {
      tag.gpgsign = true;
      commit.gpgsign = true;
      branch.autosetuprebase = "always";
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "seriousben";
      push.default = "tracking";
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

  launchd = {
    enable = true;
    agents = {
      # Delete screenshots older than 30 days.
      gc_screenshots = {
        enable = true;
        config = {
          Program = "${pkgs.findutils}/bin/find";
          # TODO: replace splitString by a function that knows about shell quoting.
          ProgramArguments = lib.strings.splitString " " "${pkgs.findutils}/bin/find ${config.home.homeDirectory}/Pictures/screenshots -type f -name *.png -mtime +30 -delete";
          RunAtLoad = false;
          KeepAlive = false;
          startInterval = 2678400; # 31 days.
          # debugging
          # StartInterval = 10;
          # StandardErrorPath = "${config.home.homeDirectory}/gc_screenshot-stderr.log";
          # StandardOutPath = "${config.home.homeDirectory}/gc_screenshot-stdout.log";
        };
      };
    };
  };
}
