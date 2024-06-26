{pkgs, ...}: {
  # all language server packages/settings
  home.packages = with pkgs; [
    bash-language-server
    gopls
    marksman
    nixd
    nodePackages.eslint
    nodePackages_latest.typescript-language-server
    vscode-langservers-extracted
  ];
}
