{
  lib,
  config,
  pkgs,
  ...
}: let
  yq-go = pkgs.symlinkJoin {
    name = "yg-go-renamed";
    paths = [pkgs.yq-go];
    postBuild = ''
      mv "$out/bin/yq" "$out/bin/yq-go"
    '';
  };

  pi-lens-detekt = pkgs.writeShellApplication {
    name = "detekt";
    text = builtins.readFile ./pi-lens/detekt;
    runtimeInputs = [pkgs.detekt];
  };

  pi-resume = pkgs.callPackage (import ./pi-resume.nix) {};
in {
  options.my.pi-coding-agent.enable = lib.mkOption {default = false;};

  config = lib.mkIf config.my.pi-coding-agent.enable {
    home.packages = [pi-resume];
    programs.pi-coding-agent = {
      enable = true;
      extraPackages = [
        pkgs.nodejs

        #pkgs.bun

        # backend START
        pkgs.kotlin-lsp

        pkgs.detekt
        pkgs.gradle
        pkgs.jdk
        pkgs.kotlin
        pi-lens-detekt
        pkgs.maven
        pkgs.typst_0_14_2
        pkgs.typstyle

        pkgs.ast-grep
        pkgs.tree-sitter

        pkgs.openapi-generator-cli

        yq-go
        # backend END
      ];
      settings = {
        theme = "dark";
        packages = [
          "npm:@zaganjade/pi-usage" # aggregated usage
          "npm:pi-fzfp" # fuzzy picker for files
          "npm:pi-lens" # lsp/linter integration
          "npm:pi-mcp-adapter" # mcp support
          "npm:pi-vim" # vim mode
          "git:github.com/jonjonrankin/pi-caveman" # caveman
        ];
      };
    };
  };
}
