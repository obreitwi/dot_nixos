{ pkgs, ... }:
{
  plugins.telescope = {
    enable = true;
    extensions = {
      file-browser = {
        enable = true;
        settings.hijack_netrw = false;
      };
      fzf-native.enable = true;
      undo.enable = true;
    };

    settings = {
      extensins = {
        ast_grep = {
          command = [
            "sg"
            "--json=stream"
          ]; # must have --json=stream
          grep_open_files = false; # search in opened files
          lang.__raw = "nil"; # string value, specify language for ast-grep `nil` for default
        };
      };
    };

    enabledExtensions = [ "ast_grep" ];
  };

  extraPlugins = [
    pkgs.vimPlugins.telescope-sg
  ];
}
