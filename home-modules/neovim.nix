{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
  dot-desktop,
  hostname,
  ...
}: {
  # NOTE: Currently treesitter parsers fail to load libstdc++6.so -> use LD_LIBRARY_PATH workaround from below
  programs.neovim = {
    enable = true;

    package = pkgs-unstable.neovim-unwrapped;

    plugins = with pkgs-unstable.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-treesitter-textobjects
      playground
      rainbow-delimiters-nvim
      pretty-fold-nvim
      nvim-autopairs
      tabout-nvim
      treesj
    ];

    viAlias = true;
    vimAlias = true;

    extraConfig =
      /*
      vim
      */
      ''
        set runtimepath^=~/.vim runtimepath+=~/.vim/after
        let &packpath = &runtimepath
        let g:nix_enabled = 1
        source ~/.vimrc
      '';
  };

  home.sessionVariables = lib.mkIf (!config.isNixOS) {
    # needed for treesitter grammar
    LD_LIBRARY_PATH = "${pkgs-unstable.stdenv.cc.cc.lib}/lib";
  };
}
