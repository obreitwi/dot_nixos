{
  config,
  lib,
  ...
}: let
  neorg-existing-day = ./neorg-existing-day;
in {
  options.my.nixvim.neorg.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.nixvim.neorg.enable {
    plugins.neorg = {
      enable = true;
      settings = {
        load = {
          "core.defaults" = {
            __empty = null;
          };
          "core.clipboard.code-blocks" = {
            __empty = null;
          }; # dedent codeblocks
          "core.concealer" = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              default_workspace = "work";
              workspaces = {
                work = "~/wiki/neorg";
                home = "~/Nextcloud/wiki";
                # example_gtd = "~/sandboxes/2022-09-17_setup_neorg/example_workspaces/gtd";
              };
            };
          };
          "core.export" = {__empty = null;};
          "core.journal" = {
            config = {
              journal_folder = "journal";
              strategy = "flat";
              workspace = "work";
              template_name = "template.norg";
            };
          };
          "core.integrations.telescope" = {
            __empty = null;
          };
          "core.esupports.indent" = {
            config = {
              modifiers = {
                "under-headings".__raw = "function(_, _) return 0 end";
              };
            };
          };
        };
      };
    };
    plugins.neorg.telescopeIntegration.enable = true;
    plugins.telescope.enable = true;

    userCommands = {
      TS.command = ":!revcli progress timelog --show --file %";
    };

    autoCmd = [
      {
        event = "FileType";
        pattern = "norg";
        command = "setlocal nolist";
      }
    ];

    extraConfigVim =
      # vim
      ''
        " Copy the name of a task in personal time tracking
        function! CopyTaskName()
            let l:save_cursor = getcurpos()
            normal! 0Ely''$
            call setpos('.', l:save_cursor)
        endfunction

        " Paste the name of a task in personal time tracking
        function! PasteTaskName()
            let l:save_cursor = getcurpos()
            normal! 0''$p
            call setpos('.', l:save_cursor)
            normal! J
        endfunction

        " Replace the name of a task in personal time tracking
        function! ReplaceTaskName()
            let l:save_cursor = getcurpos()
            normal! 0El"_D''$p
            call setpos('.', l:save_cursor)
            normal! J
            normal! zO
        endfunction

        function InsertTaskName(name)
            call append(line('.'), a:name)
            normal! J
            normal! :s/\t/ /g<CR>
            normal! :s/\s\+/ /g<CR>
        endfunction

        function InsertAsNeorgLink(input)
            let l:split=split(a:input, '	')
            let l:title=l:split[0]
            let l:title=substitute(l:title, "\{", "\\\\{", "g")
            let l:title=substitute(l:title, "\}", "\\\\}", "g")
            let l:url=l:split[1]
            call append(line('.'), printf('{%s}[%s]', l:url, l:title))
            normal! J
        endfunction

        autocmd FileType norg nmap <silent> <localleader>y :call CopyTaskName()<CR>
        autocmd FileType norg nmap <silent> <localleader>p :call PasteTaskName()<CR>
        autocmd FileType norg nmap <silent> <localleader>r :call ReplaceTaskName()<CR>0
        autocmd FileType norg nmap <silent> <localleader>s :call fzf#run(fzf#wrap({'source': 'revcli stories --list --title', 'sink': function("InsertAsNeorgLink"), 'options': '-d "	" --with-nth 1'}))<CR>
        autocmd FileType norg nmap <silent> <localleader>t :call fzf#run(fzf#wrap({'source': 'revcli tasks --list --timesheet', 'sink': function("InsertTaskName"), 'options': '-d "	" --with-nth 1'}))<CR>
        autocmd FileType norg nmap <silent> <localleader>T :call fzf#run(fzf#wrap({'source': 'revcli tasks --other --list --timesheet', 'sink': function("InsertTaskName"), 'options': '-d "	" --with-nth 1'}))<CR>
        autocmd FileType norg nmap <silent> ]d :e =system(["${neorg-existing-day}", expand("%:t:r"), "+1"])<CR><CR>
        autocmd FileType norg nmap <silent> [d :e =system(["${neorg-existing-day}", expand("%:t:r"), "-1"])<CR><CR>

        autocmd FileType norg command! -nargs=0 ReadTimeTable         read ~/wiki/neorg/template_timelog.norg
        autocmd FileType norg command! -nargs=0 ReadJournalTemplate   read ~/wiki/neorg/template_journal.norg

        " technically not part of neorg but all revcli config is here
        autocmd FileType gitcommit nmap <silent> <localleader>c :call fzf#run(fzf#wrap({'source': 'revcli stories --list --title', 'sink': function("InsertGitIDs"), 'options': '-d "	" --with-nth 1'}))<CR>

        autocmd FileType norg setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal expandtab | setlocal fo=tqnj
      '';

    extraConfigLua = ''
      local neorg_callbacks = require("neorg.core.callbacks")

      neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
          -- Map all the below keybinds only when the "norg" mode is active
          keybinds.map_event_to_mode("norg", {
              n = { -- Bind keys in normal mode
                  { "<C-s>", "core.integrations.telescope.find_linkable" },
              },

              i = { -- Bind in insert mode
                  { "<C-l>", "core.integrations.telescope.insert_link" },
              },
          }, {
              silent = true,
              noremap = true,
          })
      end)
    '';
  };
}
