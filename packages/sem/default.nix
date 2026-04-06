{
  pkgs,
  lib,
}: let
  version = "v0.3.13";
in
  pkgs.rustPlatform.buildRustPackage {
    pname = "sem";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "ataraxy-labs";
      repo = "sem";
      rev = version;
      sha256 = "sha256-4D6BmtwpZcKeV6vCpbzOfs7dY3znUGjOapjGGVTOx3Y=";
    };

    cargoHash = "sha256-Z0i1yGumKde8qb3Hd1PTXWS/CputhqbRZ4deIf0vl4s=";

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

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
