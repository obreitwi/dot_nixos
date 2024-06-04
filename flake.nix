{
  description = "Full NixOS configuration (still in evaulation phase)";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # custom (own) packages:
    asfa = {
      url = "github:obreitwi/asfa";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    dot-zsh = {
      url = "github:obreitwi/dot_zsh";
      flake = false;
    };
    pydemx = {
      url = "github:obreitwi/pydemx";
      flake = false;
    };

    # private repos:
    revcli = {
      # TODO: Confirm that this input only gets checked out if revcli is requested.
      url = "git+ssh://git@github.com/obreitwi/rev-cli-rs";
      inputs.nixpkgs.follows = "nixpkgs";
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
    nix-index-database,
    asfa,
    pydemx,
    revcli,
    dot-desktop,
    dot-vim,
    dot-zsh,
    backlight,
    blobdrop,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = [
      neorg-overlay.overlays.default
      backlight.overlays.default

      (final: prev: {
        asfa-dev = asfa.packages.${prev.system}.default;
        blobdrop = blobdrop.packages.${prev.system}.default;
        pydemx = prev.callPackage (import "${pydemx}") {}; # hacky way to include flake
        revcli = revcli.packages.${prev.system}.default;
        toggle-bluetooth-audio = prev.callPackage (import ./packages/toggle-bluetooth-audio.nix) {};
      })
    ];

    args-import = {
      inherit system overlays;
      config = {allowUnfree = true;};
    };
    pkgs-init = import nixpkgs args-import;
    nixpkgs-patched = pkgs-init.applyPatches {
      name = "nixpkgs-patched-${nixpkgs.shortRev}";
      src = nixpkgs;
      patches = [
        (pkgs-init.fetchpatch {
          url = "https://github.com/obreitwi/nixpkgs/commit/e8c7e9ee886955a265e40a6a0ea8ff94b8bf9f8f.patch";
          sha256 = "sha256-FrQfBnBTSwOliN3NFDo2tDkx7SUwH+r/NYbrCyLY/b0=";
        })
      ];
    };
    nixospkgs = (import "${nixpkgs-patched}/flake.nix").outputs {inherit self;};
    pkgs = import nixpkgs-patched args-import;
    specialArgs = hostname: {
      inherit dot-desktop dot-vim dot-zsh hostname;
      myUtils = import ./utils/lib.nix;
    };
    mySystem = hostname:
      nixospkgs.lib.nixosSystem {
        inherit system;

        modules = [
          {
            _module.args = specialArgs hostname; # make sure that regular home-modules can access special args as well
          }
          ./system/configuration.nix
          ./system/hardware-configuration/${hostname}.nix
          ./system/hardware-customization/${hostname}.nix

          # provide overlays via module
          ({...}: {nixpkgs = {inherit overlays;};})

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

    hm-modules = [
      ./home-manager/home-other.nix
      nix-index-database.hmModules.nix-index
    ];
  in {
    nixosConfigurations.nimir = mySystem "nimir";
    nixosConfigurations.mucku = mySystem "mucku";

    homeConfigurations."obreitwi@mimir" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [{_module.args = specialArgs "mimir";}] ++ hm-modules;
    };

    homeConfigurations."obreitwi@mucku" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [{_module.args = specialArgs "mucku";}] ++ hm-modules;
    };

    formatter.${system} = pkgs.alejandra;

    packages.${system} = pkgs;
  };
}
