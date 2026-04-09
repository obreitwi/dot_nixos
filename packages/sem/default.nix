{
  pkgs,
  lib,
}: let
  version = "v0.3.14";
in
  pkgs.rustPlatform.buildRustPackage {
    pname = "sem";
    inherit version;

    src = pkgs.fetchFromGitHub {
      owner = "ataraxy-labs";
      repo = "sem";
      rev = version;
      sha256 = "sha256-GcPUXrIO+L2bUrc+wvP++aLAkYXnM0zBeC1153srXLE=";
    };

    cargoHash = "sha256-mNy4vKi2DmKaHvqaRtusN7TH6XpjOiKT6aXbioisWsM=";

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
