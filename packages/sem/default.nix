{
  pkgs,
  lib,
}: let
  version = "v0.30.0";
in
  pkgs.rustPlatform.buildRustPackage {
    pname = "sem";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "ataraxy-labs";
      repo = "sem";
      rev = version;
      sha256 = "sha256-JH8/UBO62VbPu4OR59FdaxdRubA0lGoI8+f7OtlwjJA=";
    };

    cargoHash = "sha256-DQOuJP1oG95zmPaqCja+mdDFyz+6/bmfcmDbHCtugH0=";

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    buildAndTestSubdir = "crates/sem-cli";

    cargoRoot = "crates";

    buildInputs = [
      pkgs.libgit2
      pkgs.openssl
      pkgs.sqlite
      pkgs.zstd
    ];

    meta = {
      description = "A semantic versioning tool for local development";
      homepage = "https://github.com/ataraxy-labs/sem";
      license = lib.licenses.mit;
      maintainers = [lib.maintainers.obreitwi];
      mainProgram = "sem";
    };
  }
