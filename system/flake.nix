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

    # custom (own) packages:
    backlight.url =  "github:obreitwi/backlight";
    dot-desktop = {
      url = "github:obreitwi/dotfiles_desktop";
      flake = false;
    };
    pydemx = {
      url = "github:obreitwi/pydemx";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    pydemx,
    dot-desktop,
    backlight,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {allowUnfree = true;};
    };
    mySystem = hostname: let
      specialArgs = {
        pkgs-input = {inherit pydemx;};
        inherit pkgs-unstable dot-desktop backlight hostname;
      };

      homeManagerModule = path:
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.obreitwi = import "${path}";

          # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          home-manager.extraSpecialArgs = specialArgs;
        };
    in
      nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./configuration.nix
          {
            _module.args =
              specialArgs; # make sure that regular home-modules can access special args as well
          }
          ./hardware-configuration/${hostname}.nix
          ./hardware-customization/${hostname}.nix

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.obreitwi = import ../home-manager/home-nixos.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            home-manager.extraSpecialArgs = specialArgs;
          }
          # (homeManagerModule ../home-manager/home.nix)
          # (homeManagerModule (import ../home-manager/home-nixos.nix))
        ];
      };
  in {
    nixosConfigurations.nimir = mySystem "nimir";
    formatter.${system} = pkgs.nixfmt;
  };
}
