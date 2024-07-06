{
  lib,
  config,
  myUtils,
  ...
}: {
  options = {
    my.server.gitolite = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      hostName = lib.mkOption {
        type = lib.types.str;
      };
      adminPubkey = lib.mkOption {
        default = config.my.server.adminPubkey;
        type = lib.types.str;
      };
    };
  };

  config = let
    inherit (config.my.server) gitolite;
  in
    lib.mkIf gitolite.enable {
      services.gitolite = {
        enable = true;

        inherit (gitolite) adminPubkey;

        user = "git";

        # enable gitweb
        extraGitoliteRc = ''
          $RC{GIT_CONFIG_KEYS} = 'gitweb\..*';
        '';
      };

      services.nginx = {
        enable = true;

        gitweb = {
          enable = true;
          virtualHost = gitolite.hostName;
          group = config.services.gitolite.group;
          location = "";
        };
        virtualHosts."${gitolite.hostName}" = myUtils.nginxACME (myUtils.getDomain lib gitolite.hostName);
      };

      services.gitweb = {
        gitwebTheme = true;
        projectroot = "${config.services.gitolite.dataDir}/repositories";
        extraConfig = ''
          $projects_list = "${config.services.gitolite.dataDir}/projects.list";
        '';
      };
    };
}
