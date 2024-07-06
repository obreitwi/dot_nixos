{pkgs, ...}: {
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "hourly";
    localuser = null;
  };
}
