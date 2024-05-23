{
  lib,
  config,
  pkgs,
  ...
}: let
  deps = with pkgs; [revcli];
  unit = {
    Description = "Sync backlog periodically on weekdays.";
  };
in {
  options.my.revcli.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.revcli.enable {
    home.packages = deps;

    systemd.user.services.revcli-sync-backlog = {
      Unit = unit;
      Service = {
        ExecStart = "${pkgs.writeShellApplication {
          name = "revcli-sync-backlog";
          runtimeInputs = deps;
          text = ''
            revcli backlog sync
          '';
        }}/bin/revcli-sync-backlog";
      };
    };

    systemd.user.timers.revcli-sync-backlog = {
      Unit =
        unit
        // {
          After = ["network.target"];
        };
      Timer = {
        Persistent = true;
        OnCalendar = "Mon..Fri 07..19:45:00";
        RandomizedDelaySec = 900;
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
