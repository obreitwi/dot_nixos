{pkgs, ...}: let
  textobj-user = pkgs.vimUtils.buildVimPlugin {
    name = "textobj-user";
    src = pkgs.fetchFromGitHub {
    owner = "kana";
      repo = "vim-textobj-user";
      rev = "41a675ddbeefd6a93664a4dc52f302fe3086a933";
      sha256 = "1y1g3vcm97fqjyigiajbvbck4nlc04vxl3535x4sl40s5jbm5vz3";
    };
  };

  textobj-word-column = pkgs.vimUtils.buildVimPlugin {
    name = "textojb-word-column.vim";
    src = pkgs.fetchFromGitHub {
      owner = "idbrii";
      repo = "textobj-word-column.vim";
      rev = "efb8c90c889e286e569565f94bc9311c86dd7fe8";
      sha256 = "053kg618i7n8zm04z2xyqprw3hr3saq4knb59vb6ifhv1s2nqh00";
    };
  };
in {
  extraPlugins = [textobj-user textobj-word-column];
}
