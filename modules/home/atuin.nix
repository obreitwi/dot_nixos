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
          "--disable-up-arrow"
        ];

        settings = {
          auto_sync = false;
          dialect = "uk";
          keymap_mode = "vim-insert";
          update_check = false;
        };
      };

      programs.zsh.initContent =
        lib.mkOrder 1100
        /*
        sh
        */
        ''
          zvm_after_init_commands+=(
            'bindkey -M vicmd "^F" _atuin_search_widget'
            'bindkey -M viins "^F" _atuin_search_widget'
            'bindkey -M viins "^R" atuin-search-viins'
          )
        '';
    };
}
