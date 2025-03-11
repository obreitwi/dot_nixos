{
  plugins = {
    lualine = {
      enable = true;
      settings = {
        options.theme = "gruvbox";
        sections.lualine_c = [
          {
            "@" = "filename";
            path = 1;
            file_status = true;
          }
        ];
      };
    };
    web-devicons.enable = true;
  };
}
