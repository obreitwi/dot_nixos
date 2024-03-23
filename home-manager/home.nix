{ lib, config, pkgs, pkgs-unstable, pkgs-input, isNixOS, dot-desktop, hostname
, ... }:
let
  tmuxPlugins = import ../modules/tmux-plugins.nix pkgs-unstable;
  shellPackages = import ../modules/shell-packages.nix {
    inherit pkgs;
    inherit pkgs-unstable;
    inherit pkgs-input;
  };
in {
  home.packages = with pkgs-unstable;
    [
      # xmonad-with-packages
      # xmonad-contrib
      # xmonad-extras
    ] ++ shellPackages ++ tmuxPlugins;

  home.username = "obreitwi";
  home.homeDirectory = "/home/obreitwi";

  home.file."${config.xdg.configHome}/tmux/load-plugins".text =
    lib.strings.concatMapStrings (p: "run-shell " + p.rtp + "\n") tmuxPlugins;

  home.file."${config.home.homeDirectory}/.xinitrc".source =
    "${dot-desktop}/x11/xinitrc";

  # xmonad config
  home.file."${config.home.homeDirectory}/.xmonad/lib" = {
    source = "${dot-desktop}/xmonad/lib";
    recursive = true;
  };
  home.file."${config.home.homeDirectory}/.xmonad/xmonad.hs" = {
    source = "${dot-desktop}/xmonad/xmonad.hs";
  };
  home.file."${config.home.homeDirectory}/.xmonad/xmobar" = {
    source = "${dot-desktop}/xmonad/xmobar.${hostname}";
  };

  targets.genericLinux.enable = !isNixOS;

  programs.zsh.enable = false; # will overwrite zshrc
  # programs.neovim.extraPackages = [ pkgs-unstable.gcc ];

  # NOTE: Currently treesitter parsers fail to load libstdc++6.so -> use LD_LIBRARY_PATH workaround from below
  # programs.neovim.enable = true;
  # programs.neovim.package = pkgs-unstable.neovim-unwrapped;
  # programs.neovim.plugins = [
  # pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars
  # ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";

  home.sessionVariables = lib.mkMerge [
    (if isNixOS then
      { }
    else {
      # needed for treesitter grammar
      LD_LIBRARY_PATH = "${pkgs-unstable.stdenv.cc.cc.lib}/lib";
      # EDITOR = "nvim";
    })
  ];
}
