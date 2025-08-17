{
  lib,
  config,
  pkgs,
  ...
}: {
  options.my.gui.stylix.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };
  config =
    lib.mkIf (config.my.gui.enable)
    (lib.mkMerge [
      {
        gtk.enable = true;
      }

      (lib.mkIf (!config.my.gui.stylix.enable)
        {
          # gtk
          # FIXME dconf reload leads to dbus error
          dconf = {
            enable = true;
            settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
          };
          gtk.enable = true;

          gtk.cursorTheme.package = pkgs.bibata-cursors;
          gtk.cursorTheme.name = "Bibata-Modern-Ice";

          # Adwaita does not work for GTK2 which then uses an inconsistent default.
          gtk.theme.package = pkgs.adw-gtk3;
          gtk.theme.name = "adw-gtk3-dark";
          gtk.iconTheme.package = pkgs.adwaita-icon-theme;
          gtk.iconTheme.name = "Adwaita";
          gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
          # gtk.iconTheme.package = pkgs.gruvbox-dark-gtk;
          # gtk.iconTheme.name = "GruvboxDark";

          # The following themes work from GTK2 till GTK4
          # gtk.theme.package = pkgs.vimix-gtk-themes.override {
          # themeVariants = ["beryl" "doder"];
          # };
          # gtk.theme.name = "vimix-dark-beryl";
          # gtk.iconTheme.package = pkgs.adwaita-icon-theme;
          # gtk.iconTheme.name = "Adwaita";

          home.packages = with pkgs; [
            # gtk-engine-murrine # eliminate warnings

            # check settings
            lxappearance
          ];

          # qt
          qt.enable = true;
          qt.platformTheme.name = "adwaita";
          qt.style.name = "adwaita-dark";
          # qt.style.package = pkgs.adwaita-qt;
        })

      (
        lib.mkIf config.my.gui.stylix.enable {
          stylix = {
            enable = config.my.gui.stylix.enable;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

            polarity = "dark";

            targets = {
              alacritty.enable = false;
              gnome.enable = true; # even if not installed
            };
          };
        }
      )
    ]);
}
