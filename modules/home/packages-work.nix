{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.work.enable {
    home.packages = [
      #pkgs.citrix_workspace # currently marked broken
      #pkgs.webex # not working very well on Linux (cannot see others when sharingt status
    ];
  };
}
