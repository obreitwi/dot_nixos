{
  pkgs,
  nixpkgs,
  ...
}: {
  # all language server packages/settings
  home.packages = with pkgs; [
    bash-language-server
    eslint
    gopls
    lua-language-server
    marksman
    # nil # currently not used
    nixd
    nodePackages_latest.typescript-language-server
    shellcheck
    tailwindcss-language-server
    vscode-langservers-extracted
  ];

  nix.nixPath = ["nixpkgs=${nixpkgs}"];
}
