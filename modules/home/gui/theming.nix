{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (config.my.gui.enable) {
  # gtk
  # TODO: Find out why reloading dbus fails
  # gtk.enable = true;

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

  # Adwaita does not work for GTK2 which then uses an inconsistent default.
  # gtk.theme.package = pkgs.adw-gtk3;
  # gtk.theme.name = "adw-gtk3-dark";
  # gtk.iconTheme.package = pkgs.gruvbox-dark-gtk;
  # gtk.iconTheme.name = "GruvboxDark";

  # The following themes work from GTK2 till GTK4
  gtk.theme.package = pkgs.vimix-gtk-themes.override {
    themeVariants = ["beryl" "doder"];
  };
  gtk.theme.name = "vimix-dark-beryl";
  gtk.iconTheme.package = pkgs.adwaita-icon-theme;
  gtk.iconTheme.name = "Adwaita";

  # eliminate warnings
  home.packages = with pkgs; [gtk-engine-murrine];

  # qt
  qt.enable = true;
  qt.platformTheme.name = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;
}
