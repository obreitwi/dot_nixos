{
  pkgs,
  lib,
  utils,
  ...
}: let
  inherit (utils) autoCmdFT;

  vim-go = pkgs.vimUtils.buildVimPlugin {
    name = "vim-go";
    src = pkgs.fetchFromGitHub {
      owner = "fatih";
      repo = "vim-go";
      rev = "1d641b739624199ab9ab745d220f36fe7b655d65";
      sha256 = "02qfql3c6njqkq7pbzrqknca638f3fczkx651v3wwl94339ln6ky";
    };
  };
in {
  autoCmd =
    map (
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
}
