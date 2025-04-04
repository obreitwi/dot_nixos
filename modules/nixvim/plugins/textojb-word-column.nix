{pkgs, ...}: let
  textobjWordColumn = pkgs.vimUtils.buildVimPlugin {
    name = "textojb-word-column.vim";
    src = pkgs.fetchFromGitHub {
      owner = "idbrii";
      repo = "textobj-word-column.vim";
      rev = "efb8c90c889e286e569565f94bc9311c86dd7fe8";
      sha256 = "053kg618i7n8zm04z2xyqprw3hr3saq4knb59vb6ifhv1s2nqh00";
    };
  };
in {
  extraPlugins = [textobjWordColumn];
}
