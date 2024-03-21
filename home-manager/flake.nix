{
  description = "Home-manager configuraiton on top of other OSj";

  inputs = {
  # NixOS official package source, using the nixos-23.11 branch here
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  home-manager = {
    url = "github:nix-community/home-manager/release-23.11";
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of home-manager is kept consistent with
    # the `inputs.nixpkgs` of the current flake,
    # to avoid problems caused by different versions of nixpkgs.
    inputs.nixpkgs.follows = "nixpkgs";
  };
  pydemx = {
    url = "github:obreitwi/pydemx";
    flake = false;
  };
};

  outputs = { self, nixpkgs, home-manager, pydemx, ... }@inputs:
    let
      specialArgs = { inputPkgs = { inherit pydemx; }; isNixOS = false; };
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
    in {
      homeConfigurations."obreitwi" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix { _module.args = specialArgs; } ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
