{
  config,
  lib,
  ...
}: {
  options.my.nixvim.lang.css = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.css) {
    plugins.lsp.servers = {
      cssls = {
        enable = false;
        settings.scss.validate = false;
        onAttach.function = "client.server_capabilities.documentFormattingProvider = false";
      };
      stylelint_lsp = {
        enable = false; # Currently broken since depending on old pnpm 9 version with insecurities.
        settings = {
          autoFixOnFormat = true;
        };
      };
      tailwindcss.enable = false;
    };
  };
}
