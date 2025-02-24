{
  config,
  lib,
  ...
}: {
  options.my.nixvim.neorg = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.nixvim.neorg {
    extraConfigLuaPre =
      /*
      lua
      */
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
        function eeplaceTaskName()
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
