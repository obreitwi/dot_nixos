{ lib, config, pkgs, inputPkgs, isNixOS ? false, ... }:
let
  tmuxPlugins = import ../modules/tmux-plugins.nix pkgs;
  shellPackages = import ../modules/shell-packages.nix {inherit pkgs; inherit inputPkgs;};
in
{
  home.packages = shellPackages ++ tmuxPlugins;

  home.username = "obreitwi";
  home.homeDirectory = "/home/obreitwi";

  programs.zsh.enable = false; # will overwrite zshrc

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/obreitwi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "nvim";
  };
}
