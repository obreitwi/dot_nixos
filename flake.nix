{
  description = "Full NixOS configuration (still in evaulation phase)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-nixvim.url = "github:NixOS/nixpkgs/1882c6b7368fd284ad01b0a5b5601ef136321292";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprdynamicmonitors = {
      url = "github:fiffeek/hyprdynamicmonitors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      #url = "github:nix-community/nixvim/main";
      url = "github:nix-community/nixvim/63c957603751f0a107c4d9c2cbaff1c8749fc9f1";
      inputs = {
        #nixpkgs.follows = "nixpkgs";
      };
    };

    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # desktop inputs
    lanzaboote = {
      # support secure boot enabled (needed by programs running on dual booted windows)
      url = "github:nix-community/lanzaboote/v0.4.2";

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
    dot-desktop,
    dot-zsh,
    home-manager,
    hyprdynamicmonitors,
    lanzaboote,
    mailserver,
    neorg-overlay,
    neorg-task-sync,
    nix-index-database,
    nixGL,
    nixpkgs,
    nixpkgs-nixvim,
    nixpkgs-stable,
    nixvim,
    pydemx,
    revcli,
    stylix,
    ...
  }: let
    linux = "x86_64-linux";
    darwin = "aarch64-darwin";

    perSystem = system: let
      overlays = [
        neorg-overlay.overlays.default
        backlight.overlays.default

        (final: prev: {
          stable = import nixpkgs-stable args-import-nixpkgs;

          asfa-dev = asfa.packages.${prev.stdenv.hostPlatform.system}.default;
          blobdrop = blobdrop.packages.${prev.stdenv.hostPlatform.system}.default;
          grpcrl = prev.callPackage (import ./packages/grpcrl) {};
          neorg-task-sync = neorg-task-sync.packages.${prev.stdenv.hostPlatform.system}.default;
          pydemx = prev.callPackage (import "${pydemx}") {}; # hacky way to include flake
          revcli = revcli.packages.${prev.stdenv.hostPlatform.system}.default;
          toggle-bluetooth-audio = prev.callPackage (import ./packages/toggle-bluetooth-audio.nix) {};
          ptpython = prev.callPackage (import ./packages/ptpython.nix) {};
          hyprnavi = prev.callPackage (import ./packages/hyprnavi.nix) {};

          kotlin-lsp = prev.callPackage (import ./packages/kotlin-lsp) {};

          hyprdynamicmonitors = hyprdynamicmonitors.packages.${system}.default;
        })
      ];

      args-import-nixpkgs = {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };
      pkgs-init = import nixpkgs args-import-nixpkgs;

      #nixpkgs-patched = nixpkgs;
      nixpkgs-patched = pkgs-init.applyPatches {
        name = "nixpkgs-patched-${nixpkgs.shortRev}";
        src = nixpkgs;
        patches = [
          # pending update for tmux-fzf
          (pkgs-init.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/460794.diff";
            hash = "sha256-g5GAPI5CerYAwuSQ4/1w6kYx7MHjeXvdFxHV9dx/jkk=";
          })

          # nvim-treesitter-textobjects
          (pkgs-init.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/475611.diff";
            hash = "sha256-W0ma9kVzO+ZQjJY8wMx7VQvxrQjX2ENKXQAIrSgt4+w=";
          })

          # silicon patch
          (pkgs-init.fetchurl {
            url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/476595.diff";
            hash = "sha256-z9qBMdKQTsGBZtNuzeuUAaS5kBdCfIIopyvGutGzfm8=";
          })
        ];
      };

      pkgs = import nixpkgs-patched args-import-nixpkgs;
      pkgs-nixvim = import nixpkgs-nixvim args-import-nixpkgs;
      pkgs-stable = import nixpkgs-stable args-import-nixpkgs;

      # specialArgs computes inputs for nixos/hm modules
      baseSpecialArgs = {
        nixpkgs = nixpkgs-patched;
        inherit dot-desktop dot-zsh home-manager nixGL;
      };
      specialArgs = {hostname}:
        baseSpecialArgs
        // {
          myUtils = import ./utils/lib.nix;
          inherit hostname pkgs-nixvim pkgs-stable;
        };

      # nixvimLib = nixvim.lib.${system};
      nixvim' = nixvim.legacyPackages.${system};
      nixvimModule = {
        pkgs,
        specialArgs ? baseSpecialArgs,
        module ? (import ./system/nixvim),
      }: {
        inherit pkgs module; # or alternatively, set `system`
        # You can use `extraSpecialArgs` to pass additional arguments to your module files
        extraSpecialArgs = {hostname = null;} // specialArgs // (import ./modules/nixvim/utils.nix);
      };

      hm-nixvim = {module ? null}: {
        pkgs,
        pkgs-nixvim,
        hostname,
        ...
      }: let
        module' =
          if module == null
          then (import ./modules/nixvim)
          else module;
      in {
        home.packages = let
          nvim =
            nixvim'.makeNixvimWithModule
            (nixvimModule {
              pkgs = nixpkgs-nixvim;
              #inherit pkgs;
              module = module';
              specialArgs = specialArgs {inherit hostname;};
            });
        in [
          nvim
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
            ./system/home-manager/common.nix
            (hm-nixvim {})
            {my.username = username;}
          ];

          my.isNixOS = true;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit pkgs;

          modules =
            [
              stylix.nixosModules.stylix
              {
                _module.args = specialArgs {inherit hostname;}; # make sure that regular home-modules can access special args as well
                nixpkgs = {inherit overlays;};
                networking.hostName = hostname;
              }
              ./system/nixos/configuration-${type}.nix
              ./system/nixos/hardware-configuration/${hostname}.nix
              ./system/nixos/customization/${hostname}.nix

              lanzaboote.nixosModules.lanzaboote

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
        modules ? [],
        hm-module-nixvim ? null,
      }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules =
            [
              hyprdynamicmonitors.homeManagerModules.default
              stylix.homeModules.stylix
              {_module.args = specialArgs {inherit hostname;};}
              {my.username = username;}
              (hm-nixvim {module = hm-module-nixvim;})
            ]
            ++ modules ++ hm-modules-default;
        };

      hm-modules-default = [
        ./system/home-manager/non-nixos.nix
        nix-index-database.homeModules.nix-index
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
      inherit
        hm
        nixOS
        nixvim'
        nixvimModule
        pkgs
        ;

      nvim = nixvim'.makeNixvimWithModule (nixvimModule {
        inherit pkgs;
      });
    };
  in {
    checks = {
      # NOTE: Does not work as of yet: error: 'nvim' is not a valid system type, at /nix/store/…-source/flake.nix:254:7
      # nvim = nixvimLib.check.mkTestDerivationFromNixvimModule ({name = "test nvim config";} // nixvimModule);
    };

    nixosConfigurations.gentian = (perSystem linux).nixOS {
      hostname = "gentian";
      type = "server";
    };

    nixosConfigurations.mucku = (perSystem linux).nixOS {
      hostname = "mucku";
      type = "desktop";
    };
    nixosConfigurations.nimir = (perSystem linux).nixOS {
      hostname = "nimir";
      type = "desktop";
    };

    homeConfigurations."oliver.breitwieser@al-mac-150769" = (perSystem darwin).hm {
      hostname = "al-mac-150769";
      username = "oliver.breitwieser";
      modules = [
        ./system/home-manager/mac-restricted.nix
      ];
      hm-module-nixvim = import ./system/nixvim/mac-restricted.nix;
    };

    homeConfigurations."oliver.breitwieser@mimir" = (perSystem linux).hm {
      hostname = "mimir";
      username = "oliver.breitwieser";
      modules = [
        ./modules/home # default config for everything
        ./modules/home/xsession # xsession for xmonad setup
      ];
    };

    homeConfigurations."oliver.breitwieser@minir" = (perSystem linux).hm {
      hostname = "minir";
      username = "oliver.breitwieser";
      modules = [
        ./modules/home # default config for everything
        ./modules/home/xsession # xsession for xmonad setup
      ];
    };

    packages.${darwin} = {
      inherit (perSystem darwin) nvim;
    };
    packages.${linux} = {
      inherit (perSystem linux) nvim;
    };

    formatter.${linux} = (perSystem linux).pkgs.alejandra;
    formatter.${darwin} = (perSystem linux).pkgs.alejandra;
    #formatter.${system} = pkgs.nixfmt-rfc-style;
  };
}
