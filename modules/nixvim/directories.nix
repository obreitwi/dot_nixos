{
  extraConfigLuaPre =
    /*
    lua
    */
    ''
      function ensureDirExists(dir)
        if (vim.fn.isdirectory(dir) == 0) then
          if vim.fn.mkdir(dir, "p") then
            print("Created directory: " .. dir)
          else
            print("Please create directory: " .. dir)
          end
        end
      end
      ensureDirExists( os.getenv("HOME") .. '/.vimbackup' )
      ensureDirExists( os.getenv("HOME") .. '/.vimbackup/writebackup' )
      ensureDirExists( os.getenv("HOME") .. '/.vimbackup/undo' )
    '';
  opts = {
    directory = "~/.vimbackup//";
    backupdir = "~/.vimbackup/writebackup//";
    undodir = "~/.vimbackup/undo//";
    backup = true;
    undofile = true;
  };
}
