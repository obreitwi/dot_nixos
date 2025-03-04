{ utils, ... }:
let
  inherit (utils) autoCmdFT;
in
{
  autoCmd =
    [
      "setlocal spelloptions+=noplainbuffer"
      "nmap <buffer> <silent> <leader>K <Plug>(go-doc)"
      "nmap <buffer> <silent> [coc]e :GoIfErr<CR>"
      "nmap <buffer> <silent> [coc]l :GoLines<CR>"
      "nmap <buffer> <silent> [coc]m <Plug>(go-metalinter)"
      "nmap <buffer> <silent> [coc]f :GoFillStruct<CR>"
      "nmap <buffer> <silent> [coc]t <Plug>(go-test)"
    ]
    |> map (
      command:
      autoCmdFT {
        lang = "go";
        inherit command;
      }
    );

  globals = {
    go_code_completion_enabled = 0;

    go_metalinter_command = "golangci-lint";
    go_fillstruct_mode = "gopls";

    # We want a custom mapping for GoDoc
    go_doc_keywordprg_enabled = 0;
  };
}
