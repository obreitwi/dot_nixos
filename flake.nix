{
  description = "Full NixOS configuration (still in evaulation phase)";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # custom (own) packages:
    backlight = {
      url = "github:obreitwi/backlight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dot-desktop = {
      url = "github:obreitwi/dotfiles_desktop";
      flake = false;
    };
    dot-vim = {
      url = "github:obreitwi/dot_vim";
      flake = false;
    };
    pydemx = {
      url = "github:obreitwi/pydemx";
      flake = false;
    };

    # other packages:
    blobdrop = {
      url = "github:vimpostor/blobdrop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    neorg-overlay,
    pydemx,
    dot-desktop,
    dot-vim,
    backlight,
    blobdrop,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = {...}: {
      nixpkgs.overlays = [
        neorg-overlay.overlays.default
        backlight.overlays.default

        (prev: _: {
          blobdrop = blobdrop.packages.${prev.system}.default;
          pydemx = prev.callPackage (import "${pydemx}") {}; # hacky way to include flake
        })
      ];
    };
    pkgs = import nixpkgs {
      inherit system overlays;
      config = {allowUnfree = true;};
    };
    specialArgs = hostname: {
      inherit dot-desktop dot-vim hostname;
    };
    mySystem = hostname:
      nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            _module.args = specialArgs hostname; # make sure that regular home-modules can access special args as well
          }
          ./system/configuration.nix
          ./system/hardware-configuration/${hostname}.nix
          ./system/hardware-customization/${hostname}.nix

          overlays

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
      modules = [{_module.args = specialArgs "mimir";} ./home-manager/home-other.nix];
    };

    formatter.${system} = pkgs.nixfmt;
  };
}
