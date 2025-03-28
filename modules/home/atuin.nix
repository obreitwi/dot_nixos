{
  config,
  lib,
  ...
}: {
  options.my.atuin.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config =
    lib.mkIf config.my.atuin.enable
    {
      programs.atuin = {
        enable = true;
        enableZshIntegration = true;

        daemon.enable = true;

        flags = [
          #"--disable-up-arrow"
        ];

        settings = {
          auto_sync = false;
          dialect = "uk";
          filter_mode_shell_up_key_binding = "session";
          keymap_mode = "auto";
          update_check = false;
          workspaces = true;
        };
      };

      programs.zsh.initContent =
        lib.mkOrder 1100
        /*
        sh
        */
        ''
          zvm_after_init_commands+=(
            'bindkey -M vicmd "^R" atuin-search-vicmd'
            'bindkey -M viins "^R" atuin-search-viins'
          )
        '';
    };
}
