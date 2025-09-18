{
  pkgs,
  lib,
  config,
  utils,
  ...
}: let
  inherit (utils) autoCmdsFT;

  vim-go = pkgs.vimUtils.buildVimPlugin {
    name = "vim-go";
    src = pkgs.fetchFromGitHub {
      owner = "fatih";
      repo = "vim-go";
      rev = "06ac99359b0b1a7de1e213447d92fd0a46cb4cd0";
      sha256 = "19pd4kzbb1ykm4ynaxb1lqxgc95kql4a111k95vc2glx8kbq9gn6";
    };
  };
in {
  options.my.nixvim.lang.go = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.go) {
    autoCmd =
      autoCmdsFT {
        lang = "go";
      }
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
