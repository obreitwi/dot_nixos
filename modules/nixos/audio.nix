{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.audio.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.settings = {
      General = {
        Experimental = true;
      };
    };

    environment.systemPackages = with pkgs; [
      helvum # switchboard
      pavucontrol # volume control
    ];
  };
}
