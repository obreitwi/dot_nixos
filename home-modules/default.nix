{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
  dot-desktop,
  hostname,
  ...
}: let
  tmuxPlugins = import ../utility/tmux-plugins.nix pkgs-unstable;
  shellPackages = import ../utility/shell-packages.nix {
    inherit pkgs pkgs-unstable pkgs-input;
  };
in {
  imports = [
    ./alacritty.nix
    ./disable-news.nix
    ./neovim.nix
    ./readline.nix
    ./xmonad.nix
  ];

  options.isNixOS = lib.mkEnableOption "Whether or not we run on nixOS";

  config = {
    home.packages = with pkgs-unstable;
      [
        # pkgs-input.backlight.packages.x86_64-linux.default
        backlight
        blobdrop
        # # deps xmonad
        # xorg.libxcb.dev
      ]
      ++ shellPackages
      ++ tmuxPlugins;

    home.username = "obreitwi";
    home.homeDirectory = "/home/obreitwi";

    home.file."${config.xdg.configHome}/tmux/load-plugins".text =
      lib.strings.concatMapStrings (p: "run-shell " + p.rtp + "\n") tmuxPlugins;

    programs.zsh.enable = false; # will overwrite zshrc
    # programs.neovim.extraPackages = [ pkgs-unstable.gcc ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    targets.genericLinux.enable = !config.isNixOS;

    home.sessionVariables = {
      # EDITOR = "nvim";
    };
  };
}
