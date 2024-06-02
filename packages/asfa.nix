{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  ...
}: let
  version = "0.10.0";
in
  rustPlatform.buildRustPackage {
    pname = "asfa";
    inherit version;

    src = fetchFromGitHub {
      owner = "obreitwi";
      repo = "asfa";
      rev = "v${version}";
      hash = "sha256-MnhnwtZmPFhOuiqNiaxJnPu88JOdlpvyVy0YGphblBc=";
    };

    cargoHash = "sha256-/bRBP/NzcNOXl/nANeOYouUAo3NNbtbV9fxIJrNajYQ=";

    buildInputs = [
      pkgs.libssh2
    ];

    nativeBuildInputs = with pkgs; [
      gawk
      help2man
    ];

    OPENSSL_DIR = lib.attrsets.getOutput "dev" pkgs.openssl;
    OPENSSL_LIB_DIR = lib.attrsets.getOutput "lib" pkgs.openssl + "/lib";

    doCheck = false;

    postInstall = ''
      mkdir -p "$out/man/man1"
      help2man -o "$out/man/man1/asfa.1" "$out/bin/asfa"

      # Generate info about all subcommands except for 'help' (which leads to error)
      "$out/bin/asfa" --help | awk 'enabled && $1 != "help" { print $1 } /^SUBCOMMANDS:$/ { enabled=1 }' \
          | while read -r cmd; do
          help2man \
              "--version-string=${version}" \
              -o "$out/man/man1/asfa-''${cmd}.1" \
              "$out/bin/asfa ''${cmd}"
      done
    '';

    meta = with lib; {
      description = "Avoid sending file attachments by uploading them via SSH to a remote site and sharing a publicly-accessible URL with non-guessable (hash-based) prefix instead.";
      homepage = "https://github.com/obreitwi/asfa";
      changelog = "https://github.com/obreitwi/asfa/blob/v${version}/CHANGELOG.md";
      license = with licenses; [asl20 mit];
      maintainers = with maintainers; [obreitwi];
      mainProgram = "asfa";
    };
  }
