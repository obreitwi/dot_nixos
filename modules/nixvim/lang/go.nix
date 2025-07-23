{
  pkgs,
  lib,
  config,
  utils,
  ...
}: let
  inherit (utils) autoCmdFT;

  vim-go = pkgs.vimUtils.buildVimPlugin {
    name = "vim-go";
    src = pkgs.fetchFromGitHub {
      owner = "fatih";
      repo = "vim-go";
      rev = "e6788d124a564b049f3d80bef984e8bd5281286d";
      sha256 = "1gvjm1bfcjg4d6z2ka97z1ry8426mld5vay1z0n5jy7jpr8zr9zg";
    };
  };
in {
  options.my.nixvim.lang.go = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.go) {
    autoCmd =
      map
      (
        command:
          autoCmdFT {
            lang = "go";
            inherit command;
          }
      )
      [
        "setlocal spelloptions+=noplainbuffer"
        "nmap <buffer> <silent> <leader>K <Plug>(go-doc)"
        "nmap <buffer> <silent> [coc]e :GoIfErr<CR>"
        "nmap <buffer> <silent> [coc]l :GoLines<CR>"
        "nmap <buffer> <silent> [coc]m <Plug>(go-metalinter)"
        "nmap <buffer> <silent> [coc]f :GoFillStruct<CR>"
        "nmap <buffer> <silent> [coc]t <Plug>(go-test)"
      ];

    globals = {
      go_code_completion_enabled = 0;

      go_metalinter_command = "golangci-lint";
      go_fillstruct_mode = "gopls";

      # We want a custom mapping for GoDoc
      go_doc_keywordprg_enabled = 0;
    };

    extraPlugins = [vim-go];

    plugins.lsp.servers = {
      golangci_lint_ls.enable = true;
      gopls.enable = true;
    };
  };
}
