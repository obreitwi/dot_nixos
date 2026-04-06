{
  lib,
  config,
  pkgs,
  nixpkgs,
  ...
}: {
  options.my.lsp.all = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config =
    lib.mkIf config.my.lsp.all
    {
      # all language server packages/settings
      home.packages = [
        pkgs.bash-language-server
        pkgs.eslint
        pkgs.gopls
        pkgs.lua-language-server
        pkgs.marksman
        # pkgs.nil # currently not used
        pkgs.nixd
        pkgs.typescript-language-server
        pkgs.shellcheck
        pkgs.tailwindcss-language-server
        pkgs.vscode-langservers-extracted
      ];

      nix.nixPath = ["nixpkgs=${nixpkgs}"];
    };
}
