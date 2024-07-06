{
  config,
  lib,
  ...
}: {
  options.my.server = {
    rootPubkeyEnable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    adminPubkey = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = let
    inherit (config.my) server;
  in {
    users.users =
      {
        obreitwi = {
          openssh.authorizedKeys.keys = [
            server.adminPubkey
          ];
        };
      }
      // lib.mkIf server.rootPubkeyEnable {
        root = {
          openssh.authorizedKeys.keys = [
          ];
        };
      };
  };
}
