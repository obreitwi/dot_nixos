{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.go.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.go.enable {
    home.packages = with pkgs; [
      go

      (pkgs.callPackage (import ../../packages/tparse) {})

      # binaries installed by vim-go
      asmfmt
      delve
      errcheck
      godef
      golangci-lint
      golangci-lint-langserver
      gomodifytags
      gopls
      gotags
      gotools
      iferr
      impl
      motion
      reftools
      revive
    ];
  };
}
