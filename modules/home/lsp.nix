{pkgs, ...}: {
  # all language server packages/settings
  home.packages = with pkgs; [
    bash-language-server
    gopls
    marksman
    nil
    nixd
    nodePackages.eslint
    nodePackages_latest.typescript-language-server
    shellcheck
    vscode-langservers-extracted
  ];
}
