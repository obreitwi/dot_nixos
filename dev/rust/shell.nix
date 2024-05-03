{pkgs ? import <nixpkgs-unstable> {}}:
pkgs.mkShell {
  packages = with pkgs; [cargo cargo-update];
}
