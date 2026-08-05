{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  scriptsDir = "${config.home.homeDirectory}/src/seriousben/serious-nixos-config/scripts";

  # Named wrapper scripts for launchd agents
  gc-screenshots = pkgs.writeShellScript "gc-screenshots" ''
    exec ${scriptsDir}/cleanup-screenshots.sh --verbose
  '';
  organize-downloads = pkgs.writeShellScript "organize-downloads" ''
    exec ${scriptsDir}/organize-downloads.sh --verbose
  '';
in
{
  imports = [ ./user ];

  # Skip the home-configuration.nix manpage: its options.json generator
  # references the nixpkgs source without string context, which emits a build
  # warning. Options are available via nixd and the online reference instead.
  manual.manpages.enable = false;

  # macOS-specific: launchd agents
  launchd = {
    enable = true;
    agents = {
      gc_screenshots = {
        enable = true;
        config = {
          Program = "${gc-screenshots}";
          ProgramArguments = [ "${gc-screenshots}" ];
          RunAtLoad = false;
          KeepAlive = false;
          # Calendar-anchored, not startInterval: missed runs (sleep/reboot) fire
          # on next wake instead of silently never firing.
          StartCalendarInterval = {
            Hour = 12;
            Minute = 0;
          };
          StandardErrorPath = "${config.home.homeDirectory}/gc_screenshot-stderr.log";
          StandardOutPath = "${config.home.homeDirectory}/gc_screenshot-stdout.log";
        };
      };
      organize_downloads = {
        enable = true;
        config = {
          Program = "${organize-downloads}";
          ProgramArguments = [ "${organize-downloads}" ];
          RunAtLoad = false;
          KeepAlive = false;
          StartCalendarInterval = {
            Hour = 12;
            Minute = 0;
          };
          StandardErrorPath = "${config.home.homeDirectory}/organize_downloads-stderr.log";
          StandardOutPath = "${config.home.homeDirectory}/organize_downloads-stdout.log";
        };
      };
    };
  };
}
