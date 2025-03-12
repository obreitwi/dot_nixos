{
  plugins = {
    lualine = {
      enable = true;
      settings = {
        options.theme = "gruvbox";
        sections.lualine_c = [
          {
            __raw = ''{ "filename", path = 1, file_status = true }'';
          }
        ];
      };
    };
    web-devicons.enable = true;
  };
}
