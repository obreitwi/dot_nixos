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

  ## memelint has no LSP mode: efm-langserver turns its output into (error)
  ## diagnostics (see pi-lens/README.md). "=" applies to every languageId;
  ## memelint itself decides what to lint in a file.
  efmMemelintConfig = (pkgs.formats.yaml {}).generate "efm-memelint.yaml" {
    version = 2;
    languages."=" = [
      {
        lint-command = "${pkgs.memelint}/bin/memelint check \${INPUT}";
        lint-stdin = false;
        lint-ignore-exit-code = true;
        lint-after-open = true;
        lint-formats = ["%f:%l:%c: error: %m" "%f:%l:%c: warning: %m"];
        lint-severity = 1; # error: pi-lens only surfaces errors to the agent
        lint-source = "memelint";
      }
    ];
  };

  ## code/config files memelint lints comments in (markdown is handled by the
  ## marksman wrapper below, as marksman is the primary server there)
  memelintExtensions = [
    ".py"
    ".pyi"
    ".kt"
    ".kts"
    ".java"
    ".scala"
    ".nix"
    ".rs"
    ".go"
    ".c"
    ".h"
    ".cc"
    ".cpp"
    ".hpp"
    ".cs"
    ".js"
    ".jsx"
    ".mjs"
    ".ts"
    ".tsx"
    ".sh"
    ".bash"
    ".zsh"
    ".lua"
    ".rb"
    ".php"
    ".swift"
    ".sql"
    ".toml"
    ".hcl"
    ".css"
  ];

  marksman-memelint = pkgs.writeShellApplication {
    name = "marksman-memelint";
    text = ''
      exec ${pkgs.rassumfrassum}/bin/rass --log-level warn \
        -- ${pkgs.marksman}/bin/marksman server \
        -- ${pkgs.efm-langserver}/bin/efm-langserver -c ${efmMemelintConfig}
    '';
  };
in {
  options.my.pi-coding-agent.enable = lib.mkOption {default = false;};

  config = lib.mkIf config.my.pi-coding-agent.enable {
    home.packages = [
      pi-resume
      pkgs.agent-safehouse

      pkgs.memelint # to ensure it is also available locally
    ];

    ## pi-lens global config (replaces a hand-written ~/.pi-lens/config.json)
    home.file.".pi-lens/config.json".source = (pkgs.formats.json {}).generate "pi-lens-config.json" {
      format.enabled = false;
      lsp.serverOverrides.marksman.command = ["${marksman-memelint}/bin/marksman-memelint"];
      lsp.servers.memelint = {
        name = "memelint";
        extensions = memelintExtensions;
        command = "${pkgs.efm-langserver}/bin/efm-langserver";
        args = ["-c" "${efmMemelintConfig}"];
      };
    };

    programs.pi-coding-agent = {
      enable = true;
      extraPackages = [
        pkgs.nodejs

        pkgs.git

        #pkgs.bun
        # einzel-FID START
        pkgs.antiword
        pkgs.catdoc
        pkgs.pandoc
        # einzel-FID END

        # backend START
        pkgs.kotlin-lsp

        pkgs.memelint

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
        theme = "gruvbox-dark-hard";
        packages = [
          "git:https://github.com/hasit/pi-community-themes" # for theme

          "npm:@zaganjade/pi-usage" # aggregated usage

          "npm:pi-caveman" # caveman
          #"npm:agent-ste" # plain english in output (disabled because it lints everything, not just markdown)

          "npm:pi-fzfp" # fuzzy picker for files
          "npm:pi-lens" # lsp/linter integration
          "npm:pi-sandbox" # sandboxing in pi until agent safehouse certificate issues are worked out
          "npm:pi-subagents"
          "npm:pi-vim" # vim mode
          #"npm:pi-mcp-adapter" # mcp support (no provided by default)
        ];
      };
    };
  };
}
