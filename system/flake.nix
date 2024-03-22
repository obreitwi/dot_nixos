{
  description = "Full NixOS configuration (still in evaulation phase)";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
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
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
      pkgs-unstable = import nixpkgs-unstable { inherit system; config = { allowUnfree = true; }; };
      specialArgs = { inputPkgs = { inherit pydemx; }; isNixOS = true; inherit pkgs-unstable; };
    in {
      nixosConfigurations.nimir = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix
          {
            _module.args =
              specialArgs; # make sure that regular modules can access special args as well
          }
          ./hardware-configuration/nimir.nix
          ./hardware-customization/nimir.nix

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.obreitwi = import ../home-manager/home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
