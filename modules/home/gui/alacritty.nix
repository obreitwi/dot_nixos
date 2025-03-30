{
  config,
  hostname,
  lib,
  pkgs,
  ...
}: let
  bindings =
    # toml
    ''
      [[keyboard.bindings]]
      # action = "SpawnNewInstance"
      action = "CreateNewWindow"
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

  colors.custom =
    # toml
    ''
      [colors.bright]
      black = "0x808080"
      #blue = "0x0066ff"
      blue = "0x3385ff"
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
      #blue = "0x0066ff"
      blue = "0x3385ff"
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

  colors.gruvbox_dark =
    # toml
    ''
      # Colors (Gruvbox dark)
      # Default colors
      [colors.primary]
      # hard contrast background = = '#1d2021'
      background = '#282828'
      # soft contrast background = = '#32302f'
      foreground = '#ebdbb2'

      # Normal colors
      [colors.normal]
      black   = '#282828'
      red     = '#cc241d'
      green   = '#98971a'
      yellow  = '#d79921'
      blue    = '#458588'
      magenta = '#b16286'
      cyan    = '#689d6a'
      white   = '#a89984'

      # Bright colors
      [colors.bright]
      black   = '#928374'
      red     = '#fb4934'
      green   = '#b8bb26'
      yellow  = '#fabd2f'
      blue    = '#83a598'
      magenta = '#d3869b'
      cyan    = '#8ec07c'
      white   = '#ebdbb2'
    '';

  colors.gruvbox_material =
    # toml
    ''
      # Colors (Gruvbox Material Dark Medium)
      [colors.primary]
      #background = '0x282828'
      background = "0x000000"
      foreground = '0xdfbf8e'

      [colors.normal]
      black   = '0x665c54'
      red     = '0xea6962'
      green   = '0xa9b665'
      yellow  = '0xe78a4e'
      blue    = '0x7daea3'
      magenta = '0xd3869b'
      cyan    = '0x89b482'
      white   = '0xdfbf8e'

      [colors.bright]
      black   = '0x928374'
      red     = '0xea6962'
      green   = '0xa9b665'
      yellow  = '0xe3a84e'
      blue    = '0x7daea3'
      magenta = '0xd3869b'
      cyan    = '0x89b482'
      white   = '0xdfbf8e'
    '';

  colors.xterm =
    # toml
    ''
      # XTerm's default colors

      # Default colors
      [colors.primary]
      background = '#000000'
      foreground = '#ffffff'

      # Normal colors
      [colors.normal]
      black   = '#000000'
      red     = '#cd0000'
      green   = '#00cd00'
      yellow  = '#cdcd00'
      blue    = '#0000ee'
      magenta = '#cd00cd'
      cyan    = '#00cdcd'
      white   = '#e5e5e5'

      # Bright colors
      [colors.bright]
      black   = '#7f7f7f'
      red     = '#ff0000'
      green   = '#00ff00'
      yellow  = '#ffff00'
      blue    = '#5c5cff'
      magenta = '#ff00ff'
      cyan    = '#00ffff'
      white   = '#ffffff'
    '';

  font_host = {
    default =
      # toml
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

  font = font_host.${hostname} or font_host.default;

  hints =
    # toml
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
    # toml
    ''
      [window]
      opacity = 0.75
    '';
in {
  options.my.gui.alacritty.enable = lib.mkOption {
    default = true;
  };

  config = let
    inherit (config.my) gui;
  in
    lib.mkIf (gui.enable && gui.alacritty.enable) {
      home.file."${config.xdg.configHome}/alacritty/alacritty.toml".text = lib.strings.concatStrings (
        lib.strings.intersperse "\n" [
          bindings
          colors.custom
          font
          hints
          window
        ]
      );

      programs.alacritty = {
        enable = true;

        package = pkgs.alacritty;

        # NOTE: Settings defaults to yml, retry after next update.
        # settings = lib.strings.concatStrings [ bindings colors font.${hostname} hints window ];
      };
    };
}
