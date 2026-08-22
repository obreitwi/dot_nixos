# home manager config only used on desktops not running nixOS
{
  pkgs,
  lib,
  ...
}: let
  nodejs = pkgs.nodejs_22;

  yq-go = pkgs.symlinkJoin {
    name = "yg-go-renamed";
    paths = [pkgs.yq-go];
    postBuild = ''
      mv "$out/bin/yq" "$out/bin/yq-go"
    '';
  };

  direnv = {
    frontend = [
      nodejs
      pkgs.awscli2
      pkgs.corepack_22
      pkgs.eslint
      pkgs.husky
      #pkgs.node-gyp # adding it did not resolve nice-napi build errror
      pkgs.openapi-generator-cli
      pkgs.python3
      #pkgs.yarn

      yq-go
    ];
    backend = [
      pkgs.detekt
      pkgs.gradle
      pkgs.jdk
      pkgs.kotlin
      pkgs.maven
      pkgs.typst
      pkgs.typstyle
      pkgs.tinymist

      pkgs.ast-grep
      pkgs.tree-sitter

      pkgs.openapi-generator-cli

      yq-go

      # dependencies
      pkgs.jdk
      pkgs.python3
      pkgs.wdiff
    ];
  };
in {
  imports = [
    ./common.nix
  ];

  my = {
    isNixOS = false;
    isMacOS = true;

    gui.enable = false;
    gui.fonts.enable = true;

    atuin.enable = true;

    gnupg.enable = false;
    go.enable = false;

    lsp.all = false;

    packages.extended = false;

    revcli.enable = lib.mkForce true;
    revcli.sync-job = false;

    pi-coding-agent.enable = true;
  };

  programs = {
    kubecolor = {
      enable = true;
      enableAlias = true;
      enableZshIntegration = true;
    };
    k9s.enable = true;

    pi-coding-agent.settings = {
      defaultProvider = "amazon-bedrock";
      defaultModel = "eu.anthropic.claude-opus-5";
      enabledModels = ["eu.anthropic.claude-opus-5" "eu.anthropic.claude-sonnet-5"];
    };
  };

  # packages explicitly needed on mac to operate
  home.packages =
    [
      pkgs.gh

      pkgs.moreutils

      pkgs.flameshot

      pkgs.duf

      # for telescope
      pkgs.fd

      pkgs.ast-grep
      pkgs.sem-diff

      # tech-stack (supplied via shell.ni)
      # backend
      #pkgs.jdk
      #pkgs.typst
      #pkgs.typstyle

      # frontend
      #pkgs.yarn
      #pkgs.nodejs_20

      # JSON tooling
      pkgs.fixjson

      # code exploration
      pkgs.cloc
      pkgs.tokei

      # kubernetes tooling
      pkgs.kubectl
      pkgs.stable.kubelogin # latest version fails to build
      pkgs.yq

      # database
      pkgs.postgresql

      pkgs.neovide

      #pkgs.inkscape # does not work (missing icons)

      pkgs.stable.corkscrew # build failure

      # build docker
      pkgs.colima
      pkgs.docker
      pkgs.docker-compose

      pkgs.gnupg
      pkgs.p7zip

      pkgs.ptpython

      # PDF manipulation
      pkgs.poppler-utils

      pkgs.fastgron
      pkgs.sqlite-interactive

      # claude code stuff
      pkgs.awscli2
      pkgs.claude-code
      pkgs.claude-agent-acp
    ];
    #++ direnv.backend ++ direnv.frontend;

  programs.zsh = {
    initContent =
      lib.mkOrder 9000
      /*
      zsh
      */
      ''
        gh-pr-url() {
          gh pr view --json additions,deletions,title,url | jq -r '.title + " (+" + (.additions | tostring ) + "|-" + (.deletions | tostring) + "): " + .url' | pbcopy
        }
      '';
  };
}
