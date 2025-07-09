{
  config,
  lib,
  pkgs,
  ...
}: let
  nvim-silicon = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-silicon";
    src = pkgs.fetchFromGitHub {
      owner = "michaelrommel";
      repo = "nvim-silicon";
      rev = "7f66bda8f60c97a5bf4b37e5b8acb0e829ae3c32";
      sha256 = "1zk6lgghvdcys20cqvh2g1kjf661q1w97niq5nx1zz4yppy2f9jy";
    };
  };
in {
  options.my.nixvim.silicon.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.nixvim.silicon.enable {
    extraPlugins = [
      nvim-silicon
    ];

    extraConfigLua = ''
      require('nvim-silicon').setup {
        font = "IosevkaTerm NF=34;Noto Color Emoji=34",
        background = '#00000000',
        no_window_controls = true,
        to_clipboard = true,
        theme = "gruvbox-dark",
        shadow_blur_radius = 8,
        -- language = "PHP Source",
        pad_horiz = 50,
        pad_vert = 40,
        language = function()
          local lang = nil
          if vim.bo.filetype == nil or vim.bo.filetype == "" then
            -- if we cannot determine the filetype supply no default argument
            lang = vim.fn.input("Language: ", "")
          else
            -- otherwise have the filetype as preset for most cases
            lang = vim.fn.input("Language: ", vim.bo.filetype)
          end
          if lang and lang ~= "" then
            return lang
          else
            -- dialog was cancelled
            return "md"
          end
        end,
      }
    '';
  };
}
