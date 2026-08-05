{ ... }:
{
  # Trim system-profile generations older than 30d so old darwin-system builds
  # can be garbage-collected. Runs as root; the system profile is root-owned.
  # Uses StartCalendarInterval (not StartInterval) so missed runs during
  # sleep/reboot fire on next wake instead of silently never firing.
  # Note: this only unpins old generations; Determinate Nix's managed gc
  # reclaims the freed store paths automatically.
  launchd.daemons.nix-wipe-system-history = {
    script = ''
      /nix/var/nix/profiles/default/bin/nix profile wipe-history \
        --profile /nix/var/nix/profiles/system \
        --older-than 30d
    '';
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = {
        Hour = 12;
        Minute = 0;
      };
      StandardOutPath = "/var/log/nix-wipe-system-history.stdout.log";
      StandardErrorPath = "/var/log/nix-wipe-system-history.stderr.log";
    };
  };
}
