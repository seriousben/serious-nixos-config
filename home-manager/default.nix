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
          startInterval = 2678400; # 31 days
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
          startInterval = 604800; # 7 days
          StandardErrorPath = "${config.home.homeDirectory}/organize_downloads-stderr.log";
          StandardOutPath = "${config.home.homeDirectory}/organize_downloads-stdout.log";
        };
      };
    };
  };
}
