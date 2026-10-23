{
  config,
  pkgs,
  lib,
  ...
}: let
  ## atuin 18.23.0's bash-preexec e2e PTY tests fail in the Darwin build sandbox
  ## ("bash: atuin: command not found"); the zsh/fish/ble.sh variants pass, as
  ## does everything on Linux, where Hydra caches the build. Drop this override
  ## once nixpkgs' atuin builds on macOS again.
  #atuin =
  #if pkgs.stdenv.hostPlatform.isDarwin
  #then
  #pkgs.atuin.overrideAttrs (old: {
  #checkFlags =
  #old.checkFlags
  #++ [
  #"--skip=filtered_commands_leave_no_captured_output"
  #"--skip=bash_preexec"
  #];
  #})
  #else pkgs.atuin;
in {
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

        #package = atuin;

        daemon.enable = true;

        flags = [
          "--disable-up-arrow"
        ];

        settings = {
          auto_sync = false;
          dialect = "uk";
          filter_mode_shell_up_key_binding = "session";
          keymap_mode = "auto";
          update_check = false;
          workspaces = true;
          search_mode = "daemon-fuzzy";
          ai = {
            # keep AI features disabled
            enabled = false;
          };
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
            'bindkey -M vicmd "^U" atuin-up-search-vicmd'
            'bindkey -M viins "^U" atuin-up-search-viins'
          )
        '';
    };
}
