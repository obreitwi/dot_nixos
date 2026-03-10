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
            adapters = {
            claude_code = function()
              return require("codecompanion.adapters").extend("claude_code", {
                commands = {
                  default = { "claude-code-acp" }, -- use until nix package has adapted to rename
                }
              })
            end,
          },
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
