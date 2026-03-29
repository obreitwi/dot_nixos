{
  pkgs,
  lib,
}: let
  version = "v0.3.10";
in
  pkgs.rustPlatform.buildRustPackage {
    pname = "sem";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "ataraxy-labs";
      repo = "sem";
      rev = version;
      sha256 = "sha256-H/VjtBEXtE9hwBS/uqo9Hp0FQ76kT2XxpB4kGJDZxRs="; # See instructions below to update this
    };

    # This hash is for the cargo dependencies.
    # Set to pkgs.lib.fakeHash initially, then update after the first build attempt.
    cargoHash = "sha256-+bBWrEioPGoUJHykGaMGyLunPM5cfrWDRXan3JDcXPs=";

    # Build-time dependencies
    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.rustPlatform.cargoSetupHook
    ];

    # Point Nix to the specific crate within the workspace
    buildAndTestSubdir = "crates/sem-cli";

    cargoRoot = "crates";

    buildInputs = [
      pkgs.openssl
    ];

    meta = {
      description = "A semantic versioning tool for local development";
      homepage = "https://github.com/ataraxy-labs/sem";
      license = lib.licenses.mit;
      maintainers = [lib.maintainers.obreitwi];
      mainProgram = "sem";
    };
  }
