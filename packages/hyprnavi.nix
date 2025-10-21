{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "hyprnavi";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ckaznable";
    repo = "hyprnavi";
    rev = "7be863ca65a7d49c0b11329a70f206c07a3b6bf3";
    hash = "sha256-KMBd3VGyAqUrhuveKlbC2CWZ1aHzsBXYK6KE1Ii1F6c=";
  };

  cargoHash = "sha256-7BZettbtOVucNqm57Elkj0RDBmLIYdeRwLxv0Q/AQL8=";
}
