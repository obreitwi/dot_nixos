{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
  dot-desktop,
  hostname,
  ...
}: let
  bindings =
    /*
    toml
    */
    ''
      [[keyboard.bindings]]
      action = "SpawnNewInstance"
      key = "Return"
      mods = "Control|Shift"

      [[keyboard.bindings]]
      action = "Paste"
      key = "L"
      mods = "Alt"

      [[keyboard.bindings]]
      action = "PasteSelection"
      key = "L"
      mods = "Alt|Shift"

      [[keyboard.bindings]]
      chars = "\u001B[74;3u"
      key = "J"
      mods = "Alt|Shift"

      [[keyboard.bindings]]
      chars = "\u001B[75;3u"
      key = "K"
      mods = "Alt|Shift"
    '';

  colors =
    /*
    toml
    */
    ''
      [colors.bright]
      black = "0x808080"
      blue = "0x0066ff"
      cyan = "0x00ffff"
      green = "0x33ff00"
      magenta = "0xcc00ff"
      red = "0xfe0100"
      white = "0xFFFFFF"
      yellow = "0xfeff00"

      [colors.cursor]
      cursor = "0xffffff"
      text = "0xF81CE5"

      [colors.normal]
      black = "0x000000"
      blue = "0x0066ff"
      cyan = "0x00ffff"
      green = "0x33ff00"
      magenta = "0xcc00ff"
      red = "0xfe0100"
      white = "0xd0d0d0"
      yellow = "0xfeff00"

      [colors.primary]
      background = "0x000000"
      foreground = "0xffffff"
    '';

  font = {
    mimir =
      /*
      toml
      */
      ''
        [font]
        size = 10

        [font.glyph_offset]
        x = 0
        y = 0

        [font.offset]
        x = 0
        y = 0

        [font.bold]
        family = "IosevkaTerm NF"
        style = "Bold"

        [font.italic]
        family = "IosevkaTerm NF"
        style = "Oblique"

        [font.normal]
        family = "IosevkaTerm NF"
        style = "Regular"
      '';
  };

  hints =
    /*
    toml
    */
    ''
      [[hints.enabled]]
      command = "xdg-open"
      post_processing = true
      regex = "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F<>\"\\s{-}\\^⟨⟩`]+"

      [hints.enabled.binding]
      key = "U"
      mods = "Alt"

      [hints.enabled.mouse]
      enabled = true
      mods = "None"

      [[hints.enabled]]
      action = "Copy"
      post_processing = true
      regex = "(ipfs:|ipns:|magnet:|mailto:|gemini:|gopher:|https:|http:|news:|file:|git:|ssh:|ftp:)[^\u0000-\u001F<>\"\\s{-}\\^⟨⟩`]+"

      [hints.enabled.binding]
      key = "Y"
      mods = "Alt"

      [hints.enabled.mouse]
      enabled = true
      mods = "Shift"
    '';

  window =
    /*
    toml
    */
    ''
      [window]
      opacity = 0.75
    '';
in {
  options.my.alacritty.enable = lib.mkOption {
    default = true;
  };

  config = lib.mkIf config.my.alacritty.enable {
    home.file."${config.xdg.configHome}/alacritty/alacritty.toml".text = lib.strings.concatStrings (lib.strings.intersperse "\n" [bindings colors font.${hostname} hints window]);

    programs.alacritty = {
      enable = true;

      package = pkgs-unstable.alacritty;

      # NOTE: Settings defaults to yml, retry after next update.
      # settings = lib.strings.concatStrings [ bindings colors font.${hostname} hints window ];
    };
  };
}
