{
  extraConfigLuaPre =
    # lua
    ''
      if vim.uv.fs_stat(vim.fn.expand("$HOME/.config/nvim/nvimrc.local")) then
        vim.cmd.source(vim.fn.expand("$HOME/.config/nvim/nvimrc.local"))
      end
    '';
}
