{
  lib,
  stdenv,
  fetchzip,
  openjdk,
  makeWrapper,
}: let
  version = "0.252.17811";
in
  stdenv.mkDerivation {
    pname = "kotlin-lsp";
    inherit version;
    src = fetchzip {
      url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-${version}.zip";
      hash = "sha256-yplwz3SQzUIYaOoqkvPEy8nQ5p3U/e1O49WNxaE7p9Y=";
      stripRoot = false;
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/lib
      mkdir -p $out/bin
      cp -r lib/* $out/lib
      cp kotlin-lsp.sh $out/kotlin-lsp
      chmod +x $out/kotlin-lsp
    '';

    nativeBuildInputs = [
      makeWrapper
    ];
    buildInputs = [
      openjdk
    ];

    postFixup = ''
      wrapProgram "$out/kotlin-lsp" --set JAVA_HOME ${openjdk} --prefix PATH : ${
        lib.strings.makeBinPath [
          openjdk
        ]
      }
      ln -s $out/kotlin-lsp $out/bin
    '';

    meta = {
      description = "kotlin language server";
      longDescription = ''
        About Kotlin code completion, linting and more for any editor/IDE
        using the Language Server Protocol Topics (official, but pre-alpha)'';
      maintainers = with lib.maintainers; [obreitwi];
      #homepage = "https://github.com/fwcd/kotlin-language-server";
      #changelog = "https://github.com/fwcd/kotlin-language-server/blob/${version}/CHANGELOG.md";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      sourceProvenance = [lib.sourceTypes.binaryBytecode];
    };
  }
