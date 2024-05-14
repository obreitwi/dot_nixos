{pkgs, ...}: {
  # gtk
  gtk.enable = true;

  gtk.cursorTheme.package = pkgs.bibata-cursors;
  gtk.cursorTheme.name = "Bibata-Modern-Ice";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3-dark";

  gtk.iconTheme.package = pkgs.gruvbox-dark-gtk;
  gtk.iconTheme.name = "GruvboxDark";

  home.sessionVariables = {
     GTK_THEME = "Adwaita:dark";
  };

  # qt
  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;
}
