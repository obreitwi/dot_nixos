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

    # server packages:
    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
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
      # TODO: Pending fix in neorg-task-sync dependencies
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    pydemx = {
      url = "github:obreitwi/pydemx";
      flake = false;
    };

    # private repos:
    revcli = {
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
    mailserver,
    nixpkgs,
    nixpkgs-stable,
    pydemx,
    revcli,
    ...
  }: let
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
          ./patches/nixpkgs/revert_pr_319233.patch
        ];
      };

    pkgs = import nixpkgs-patched args-import-nixpkgs;
    pkgs-stable = import nixpkgs-stable args-import-nixpkgs;

    # specialArgs computs inputs for nixos/hm modules
    specialArgs = {
      hostname,
      username,
    }: {
      inherit dot-desktop dot-vim dot-zsh hostname pkgs-stable username;
      myUtils = import ./utils/lib.nix;
    };

    nixOS = {
      type,
      hostname,
      username ? "obreitwi",
    }:
      nixpkgs.lib.nixosSystem {
        inherit pkgs;

        modules =
          [
            {
              _module.args = specialArgs {inherit hostname username;}; # make sure that regular home-modules can access special args as well
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

                my.isNixOS = true;
              };

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.extraSpecialArgs = specialArgs {inherit hostname username;};
            }
          ]
          ++ (nixpkgs.lib.optionals (type == "server") [mailserver.nixosModules.default]);
      };
    hm = {
      hostname,
      username,
    }:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [{_module.args = specialArgs {inherit hostname username;};}] ++ hm-modules;
      };

    hm-modules = [
      ./home-manager/non-nixos.nix
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

    homeConfigurations."oliver.breitwieser@mimir" = hm {
      hostname = "mimir";
      username = "oliver.breitwieser";
    };

    formatter.${system} = pkgs.alejandra;
  };
}
