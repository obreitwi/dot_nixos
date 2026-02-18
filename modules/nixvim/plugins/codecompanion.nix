{
  config,
  lib,
  ...
}: {
  options.my.nixvim.codecompanion.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.nixvim.codecompanion.enable {
    plugins.codecompanion = {
      enable = true;

      settings.__raw = ''
        {
          interactions = {
            chat = {
              adapter = "claude_code",
            },
            inline = {
              adapter = "claude_code",
            },
            cmd = {
              adapter = "claude_code",
            },
          },
        }
      '';
    };

    keymaps = [
      {
        key = "[unite]C";
        mode = "n";
        action = ":Telescope codecompanion<CR>";
      }
    ];
  };
}
