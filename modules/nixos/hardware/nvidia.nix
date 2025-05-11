{config, ...}:
{
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = { 
    modesetting.enable = true;

    powerManagement = {
      enable = false;
      finegrained = false;
    };

    open = true; # recommended for newer cards
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
