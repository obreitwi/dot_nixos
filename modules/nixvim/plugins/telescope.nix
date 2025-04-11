{pkgs, ...}: {
  plugins.telescope = {
    enable = true;
    extensions = {
      file-browser = {
        enable = true;
        settings.hijack_netrw = false;
      };
      fzf-native.enable = true;
      undo.enable = true;
    };

    settings = {
      extensins = {
        ast_grep = {
          command = [
            "${pkgs.ast-grep}/bin/ast-grep"
            "--json=stream"
          ]; # must have --json=stream
          grep_open_files = false; # search in opened files
          lang.__raw = "nil"; # string value, specify language for ast-grep `nil` for default
        };
      };
    };

    enabledExtensions = ["ast_grep"];
  };

  extraPlugins = [
    pkgs.vimPlugins.telescope-sg
  ];

  extraConfigLua =
    # lua
    ''
      vim.keymap.set("n", "<leader>lf", ":Telescope file_browser<CR>", {silent = true})
      vim.keymap.set("n", "<leader>lr", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { silent = true})
      vim.keymap.set("n", "[unite]s", ":Telescope file_browser path=~/doc/scratchpad select_buffer=true<CR>", { silent = true})
    '';

  extraConfigVim =
    # vim
    ''
      nmap <silent> <c-p> :lua require'telescope.builtin'.git_files{}<CR>
      nmap <silent> <leader>be :lua require'telescope.builtin'.buffers{}<CR>
      nmap <silent> [unite]/ :lua require'telescope.builtin'.search_history{}<CR>
      nmap <silent> [unite]: :lua require'telescope.builtin'.command_history{}<CR>
      nmap <silent> [unite]f :lua require'telescope.builtin'.find_files{}<CR>
      nmap <silent> [unite]c :lua require'telescope.builtin'.commands{}<CR>
      nmap <silent> [unite]R :lua require'telescope.builtin'.registers{}<CR>
      nmap <silent> [unite]u<leader> :lua require'telescope.builtin'.resume{}<CR>
      nmap <silent> [unite]l :lua require'telescope.builtin'.current_buffer_fuzzy_find{}<CR>
      nmap <silent> [unite]m :lua require'telescope.builtin'.oldfiles{}<CR>
      nmap <silent> [unite]M :lua require'telescope.builtin'.keymaps{}<CR>
      vmap <silent> [unite]r :lua require'telescope.builtin'.grep_string{initial_mode='select'}<CR>
      nmap <silent> [unite]r :lua require'telescope.builtin'.grep_string{}<CR>
      nmap <silent> [unite]g :lua require'telescope.builtin'.live_grep{}<CR>
      nmap <silent> [unite]G :lua require'telescope.builtin'.live_grep{cwd = require'telescope.utils'.buffer_dir()}<CR>
      nmap <silent> [unite]h :lua require'telescope.builtin'.help_tags{}<CR>
      nmap <silent> [unite]a :Telescope ast_grep<CR>

      " coc bindings
      nmap <silent> [coc]D   :lua require'telescope.builtin'.diagnostics{}<CR>
      nmap <silent> [coc]d   :lua require'telescope.builtin'.lsp_definitions{}<CR>
      nmap <silent> [coc]t   :lua require'telescope.builtin'.lsp_type_definitions{}<CR>
      nmap <silent> [coc]r   :lua require'telescope.builtin'.lsp_references{}<CR>
      nmap <silent> [coc]ci  :lua require'telescope.builtin'.lsp_incoming_calls{}<CR>
      nmap <silent> [coc]co  :lua require'telescope.builtin'.lsp_outgoing_calls{}<CR>
      nmap <silent> [coc]S   :lua require'telescope.builtin'.lsp_dynamic_workspace_symbols{fname_width=40, symbol_width=80}<CR>
      nmap <silent> [coc]s   :lua require'telescope.builtin'.lsp_document_symbols{fname_width=40, symbol_width=80}<CR>
    '';
}
