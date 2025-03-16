{
  description = "Full NixOS configuration (still in evaulation phase)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    neorg-overlay = {
      # url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      # Use fix branch until merged https://github.com/nvim-neorg/nixpkgs-neorg-overlay/pull/11
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
      inputs.nixpkgs.follows = "nixpkgs";
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
    };
  };

  outputs = {
    asfa,
    backlight,
    blobdrop,
    home-manager,
    nixvim,
    neorg-overlay,
    neorg-task-sync,
    nix-index-database,
    mailserver,
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
        stable = import nixpkgs-stable args-import-nixpkgs;

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
      config = {
        allowUnfree = true;
      };
    };
    pkgs-init = import nixpkgs args-import-nixpkgs;

    nixpkgs-patched = pkgs-init.applyPatches {
      name = "nixpkgs-patched-${nixpkgs.shortRev}";
      src = nixpkgs;
      patches = [
        #(pkgs-init.fetchurl {
        #url = "https://github.com/NixOS/nixpkgs/pull/389674.diff";
        #hash = "sha256-F6THEVdLQ9NBE+KMDElc5jWgvso5IkOrYaYDgxEViZU=";
        #})
        # ./patches/nixpkgs/revert_pr_344849.patch
      ];
    };

    pkgs = import nixpkgs-patched args-import-nixpkgs;
    pkgs-stable = import nixpkgs-stable args-import-nixpkgs;

    # specialArgs computs inputs for nixos/hm modules
    baseSpecialArgs = {
      inherit inputs;
    };
    specialArgs = {hostname}:
      baseSpecialArgs
      // {
        myUtils = import ./utils/lib.nix;
        inherit hostname pkgs-stable;
      };

    # nixvimLib = nixvim.lib.${system};
    nixvim' = nixvim.legacyPackages.${system};
    nixvimModule = {
      pkgs,
      specialArgs ? baseSpecialArgs,
    }: {
      inherit pkgs; # or alternatively, set `system`
      module = import ./modules/nixvim; # import the module directly
      # You can use `extraSpecialArgs` to pass additional arguments to your module files
      extraSpecialArgs = {hostname = null;} // specialArgs // import ./modules/nixvim/utils.nix;
    };

    hm-nixvim = {
      pkgs,
      hostname,
      ...
    }: {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "nnvim";
          runtimeInputs = [
            (nixvim'.makeNixvimWithModule (nixvimModule {
              inherit pkgs;
              specialArgs = specialArgs {inherit hostname;};
            }))
          ];
          text = ''
            exec nvim "$@"
          '';
        })
      ];
    };

    nixOS = {
      type,
      hostname,
      username ? "obreitwi",
    }: let
      hm-user = {username}: {...}: {
        imports = [
          ./modules/home
          ./home-manager/common.nix
          hm-nixvim
          {my.username = username;}
        ];

        my.isNixOS = true;
      };
    in
      nixpkgs.lib.nixosSystem {
        inherit pkgs;

        modules =
          [
            {
              _module.args = specialArgs {inherit hostname;}; # make sure that regular home-modules can access special args as well
              nixpkgs = {inherit overlays;};
              networking.hostName = hostname;
            }
            ./system/configuration-${type}.nix
            ./system/hardware-configuration/${hostname}.nix
            ./system/customization/${hostname}.nix

            nix-index-database.nixosModules.nix-index

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true; # NOTE: Needs to be set for custom pkgs built in flake to be used!
              home-manager.useUserPackages = true; # NOTE: Needs to be set for custom pkgs built in flake to be used!

              home-manager.users =
                {
                  ${username} = hm-user {inherit username;};
                }
                // (
                  if (builtins.elem hostname ["gentian"])
                  then {
                    root = hm-user {username = "root";};
                  }
                  else {}
                );

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
              home-manager.extraSpecialArgs = specialArgs {inherit hostname;};
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
        modules =
          [
            {_module.args = specialArgs {inherit hostname;};}
            {my.username = username;}
          ]
          ++ hm-modules;
      };

    hm-modules = [
      ./home-manager/non-nixos.nix
      nix-index-database.hmModules.nix-index
      hm-nixvim
      (
        {
          lib,
          config,
          ...
        }:
          lib.mkIf (!config.my.isNixOS) {
            nix.registry = {
              nixpkgs.flake = nixpkgs;
              nixpkgs-stable.flake = nixpkgs-stable;
            };
          }
      )
    ];
  in {
    checks = {
      # NOTE: Does not work as of yet: error: 'nvim' is not a valid system type, at /nix/store/…-source/flake.nix:254:7
      # nvim = nixvimLib.check.mkTestDerivationFromNixvimModule ({name = "test nvim config";} // nixvimModule);
    };

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

    packages.${system} = {
      nvim = nixvim'.makeNixvimWithModule (nixvimModule {
        inherit pkgs;
      });
    };

    formatter.${system} = pkgs.alejandra;
    #formatter.${system} = pkgs.nixfmt-rfc-style;
  };
}
