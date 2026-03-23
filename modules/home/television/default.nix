{
  nixvimOptions,
  pkgs,
  ...
}: {
  imports = [./channels];

  programs.television = {
    enable = true;

    enableZshIntegration = false; # still using ctrl-t

    settings = {
      theme = "gruvbox-dark";
    };
  };

  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;

    settings = {
      experimental.options_file = {
        nixvim = nixvimOptions;
      };
    };
  };

  programs.zsh.shellAliases = {
    "ns" = "tv nix-search-tv";
  };
}
