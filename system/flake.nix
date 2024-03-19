{
  description = "Full NixOS configuraiton (still in evaulation phase)";

  inputs = {
  # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    pydemx = {
      url = "github:obreitwi/pydemx";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, pydemx, ... }:
    let
      customInputs = {
        pydemx = pydemx;
      };
    in
    {
      nixosConfigurations.nimir = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          (import ./configuration.nix customInputs )
          ./hardware-configuration/nimir.nix
          ./hardware-customization/nimir.nix
        ];
      };
    };
}
