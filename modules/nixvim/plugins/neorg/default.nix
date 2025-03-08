{
  config,
  lib,
  ...
}: let
  neorg-existing-day = ./neorg-existing-day;
in {
  options.my.nixvim.neorg = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.nixvim.neorg {
    plugins.neorg.enable = true;
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
        autocmd FileType norg nmap <silent> <localleader>y :call CopyTaskName()<CR>
        autocmd FileType norg nmap <silent> <localleader>p :call PasteTaskName()<CR>
        autocmd FileType norg nmap <silent> <localleader>r :call ReplaceTaskName()<CR>0
        autocmd FileType norg nmap <silent> <localleader>s :call fzf#run(fzf#wrap({'source': 'revcli stories --list --title', 'sink': function("InsertAsNeorgLink"), 'options': '-d "	" --with-nth 1'}))<CR>
        autocmd FileType norg nmap <silent> <localleader>t :call fzf#run(fzf#wrap({'source': 'revcli tasks --list --timesheet', 'sink': function("InsertTaskName"), 'options': '-d "	" --with-nth 1'}))<CR>
        autocmd FileType norg nmap <silent> <localleader>T :call fzf#run(fzf#wrap({'source': 'revcli tasks --other --list --timesheet', 'sink': function("InsertTaskName"), 'options': '-d "	" --with-nth 1'}))<CR>

        " technically not part of neorg but all revcli config is here
        autocmd FileType gitcommit nmap <silent> <localleader>c :call fzf#run(fzf#wrap({'source': 'revcli stories --list --title', 'sink': function("InsertGitIDs"), 'options': '-d "	" --with-nth 1'}))<CR>

        autocmd FileType norg nmap <silent> ]d :e =system(["${neorg-existing-day}", expand("%:t:r"), "+1"])<CR><CR>
        autocmd FileType norg nmap <silent> [d :e =system(["${neorg-existing-day}", expand("%:t:r"), "-1"])<CR><CR>

        autocmd FileType norg setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal expandtab | setlocal fo=tqnj
      '';

    extraConfigLuaPre =
      # lua
      ''
        -- Copy the name of a task in personal time tracking
        function copyTaskName()
            local save_cursor = vim.fn.getcurpos()
            vim.cmd("normal! 0Ely$")
            vim.fn.setpos('.', save_cursor)
        end

        -- Paste the name of a task in personal time tracking
        function pasteTaskName()
            local save_cursor = vim.fn.getcurpos()
            vim.cmd("normal! 0$p")
            vim.fn.setpos('.', save_cursor)
        end

        -- Replace the name of a task in personal time tracking
        function replaceTaskName()
            local save_cursor = vim.fn.getcurpos()
            vim.cmd('normal! 0El"_D$p')
            vim.fn.setpos('.', save_cursor)
            vim.cmd("normal! zO")
        end

        function insertTaskName(name)
            vim.fn.append(vim.fn.line('.'), name)
            vim.cmd('normal! J')
            vim.cmd('normal! :s/\t/ /g<CR>')
            vim.cmd('normal! :s/\s\+/ /g<CR>')
        end

        function insertAsNeorgLink(input)
            local split = vim.fn.split(input, '	')
            local title = split[1]
            title = vim.fn.substitute(title, "\{", "\\\\{", "g")
            title = vim.fn.substitute(title, "\}", "\\\\}", "g")
            local url = split[2]
            vim.fn.append(vim.fn.line('.'), vim.fn.printf('{%s}[%s]', url, title))
            vim.cmd("normal! J")
        end

        function insertTaskDetails(title_details)
            local split = vim.fn.split(title_details, '	')
            local title = split[1]
            local details = split[2]
            vim.fn.append(line('.'), title .. ' #STORY ' .. details)
            vim.cmd("normal! J")
            vim.cmd("normal! zO")
        end
      '';
  };
}
