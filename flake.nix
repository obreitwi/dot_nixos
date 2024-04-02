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
    backlight = {
      url = "github:obreitwi/backlight";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dot-desktop = {
      url = "github:obreitwi/dotfiles_desktop";
      flake = false;
    };
    pydemx = {
      url = "github:obreitwi/pydemx";
      flake = false;
    };

    # other packages:
    blobdrop = {
      url = "github:vimpostor/blobdrop";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    blobdrop,
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
      overlays = [
        backlight.overlays.default
        (prev: _: {blobdrop = blobdrop.packages.${prev.system}.default;})
      ];
    };
    specialArgs = hostname: {
      pkgs-input = {inherit backlight blobdrop pydemx;};
      inherit dot-desktop hostname pkgs-unstable;
    };
    mySystem = hostname:
      nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
          {
            _module.args = specialArgs hostname; # make sure that regular home-modules can access special args as well
          }
          ./system/hardware-configuration/${hostname}.nix
          ./system/hardware-customization/${hostname}.nix

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.obreitwi = import ./home-manager/home-nixos.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            home-manager.extraSpecialArgs = specialArgs hostname;
          }
        ];
      };
  in {
    nixosConfigurations.nimir = mySystem "nimir";

    homeConfigurations."obreitwi@mimir" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home-manager/home-other.nix {_module.args = specialArgs "mimir";}];
    };

    formatter.${system} = pkgs.nixfmt;
  };
}
