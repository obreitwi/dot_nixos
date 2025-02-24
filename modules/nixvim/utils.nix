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
    '';
}
