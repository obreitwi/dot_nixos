{
  description = "Full NixOS configuration (still in evaulation phase)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
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
    neorg-task-sync = {
      url = "github:obreitwi/neorg-task-sync?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
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
    asfa,
    backlight,
    blobdrop,
    dot-desktop,
    dot-vim,
    dot-zsh,
    home-manager,
    neorg-overlay,
    neorg-task-sync,
    nix-index-database,
    nixpkgs,
    nixpkgs-stable,
    pydemx,
    revcli,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    overlays = [
      neorg-overlay.overlays.default
      backlight.overlays.default

      (final: prev: {
        asfa-dev = asfa.packages.${prev.system}.default;
        blobdrop = blobdrop.packages.${prev.system}.default;
        grpcrl = prev.callPackage (import ./packages/grpcrl) {};
        neorg-task-sync = neorg-task-sync.packages.${prev.system}.default;
        pydemx = prev.callPackage (import "${pydemx}") {}; # hacky way to include flake
        revcli = revcli.packages.${prev.system}.default;
        toggle-bluetooth-audio = prev.callPackage (import ./packages/toggle-bluetooth-audio.nix) {};
      })
    ];

    args-import-nixpkgs = {
      inherit system overlays;
      config = {allowUnfree = true;};
    };
    pkgs-init = import nixpkgs args-import-nixpkgs;
    nixpkgs-patched =
      pkgs-init.applyPatches
      {
        name = "nixpkgs-patched-${nixpkgs.shortRev}";
        src = nixpkgs;
        patches = [
        ];
      };

    pkgs = import nixpkgs-patched args-import-nixpkgs;
    pkgs-stable = import nixpkgs-stable args-import-nixpkgs;

    # specialArgs computs inputs for nixos/hm modules
    specialArgs = hostname: {
      inherit dot-desktop dot-vim dot-zsh hostname pkgs-stable;
      myUtils = import ./utils/lib.nix;
    };

    nixOS = {
      type,
      hostname,
    }:
      nixpkgs.lib.nixosSystem {
        inherit pkgs;

        modules = [
          {
            _module.args = specialArgs hostname; # make sure that regular home-modules can access special args as well
            nixpkgs = {inherit overlays;};
            networking.hostName = hostname;
          }
          ./system/configuration-${type}.nix
          ./system/hardware-configuration/${hostname}.nix
          ./system/customization/${hostname}.nix

          nix-index-database.nixosModules.nix-index
          {programs.nix-index-database.comma.enable = true;}

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true; # NOTE: Needs to be set for custom pkgs built in flake to be used!
            home-manager.useUserPackages = true; # NOTE: Needs to be set for custom pkgs built in flake to be used!

            home-manager.users.obreitwi = {...}: {
              imports = [
                ./modules/home
                ./home-manager/common.nix
              ];

              isNixOS = true;
            };

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            home-manager.extraSpecialArgs = specialArgs hostname;
          }
        ];
      };
    hm = hostname:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [{_module.args = specialArgs hostname;}] ++ hm-modules;
      };

    hm-modules = [
      ./home-manager/home-other.nix
      nix-index-database.hmModules.nix-index
      {programs.nix-index-database.comma.enable = true;}
    ];
  in {
    nixosConfigurations.gentian = nixOS {
      hostname = "gentian";
      type = "server";
    };

    nixosConfigurations.mucku = nixOS {
      hostname = "mucku";
      type = "desktop";
    };
    nixosConfigurations.nimir = nixOS {
      hostname = "nimir";
      type = "desktop";
    };

    homeConfigurations."obreitwi@mimir" = hm "mimir";

    formatter.${system} = pkgs.alejandra;
  };
}
