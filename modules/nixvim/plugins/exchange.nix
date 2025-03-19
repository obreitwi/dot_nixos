{pkgs, ...}: let
  exchange = pkgs.vimUtils.buildVimPlugin {
    name = "vim-exchange";
    src = pkgs.fetchFromGitHub {
      owner = "tommcdo";
      repo = "vim-exchange";
      rev = "d6c1e9790bcb8df27c483a37167459bbebe0112e";
      sha256 = "0rr8858w0q2a0y7ijag2ja61qay7nqwzd9g8lknn84np9j29lfmf";
    };
  };
in {
  extraPlugins = [exchange];
}
