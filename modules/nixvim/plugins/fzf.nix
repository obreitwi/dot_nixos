{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "2a92c7d792b45112ab82eef0be2aa11038e6185d";
      sha256 = "0yi8i1snqchki4nkaqdn0ff0zld14sv1im1mvni684cazjdd7rp9";
    };
  };
  fzf_vim = pkgs.vimUtils.buildVimPlugin {
    name = "fzf.vim";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "879db51d0965515cdaef9b7f6bdeb91c65d2829e";
      sha256 = "0s889l2vcq2mw6x2iiqx8kmma97k3zx2yazwpbdca93z9dsnk7k9";
    };
  };
in {
  extraPlugins = [
    fzf
    fzf_vim
  ];
}
