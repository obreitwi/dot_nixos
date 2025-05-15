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
    };
}
