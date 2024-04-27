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
    dot-zsh = {
      url = "github:obreitwi/dot_zsh";
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
        blobdrop = blobdrop.packages.${prev.system}.default;
        pydemx = prev.callPackage (import "${pydemx}") {}; # hacky way to include flake
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
          # azure-devops extension
          (pkgs-init.fetchpatch {
            url = "https://github.com/NixOS/nixpkgs/commit/ec6915ff518ff28ea419f798640d6f62839ff06d.patch";
            sha256 = "ThRA7QutJanyDeOWCoNVYLuU6bqEQREu5d8t2OPXlyM=";
          })
          (pkgs-init.fetchpatch {
            url = "https://github.com/NixOS/nixpkgs/commit/d566b7894a3f6fa043f5637e247650d3fe7db218.patch";
            sha256 = "nU5BJ1sA3a79UXkBDCcIMBhnJpEQ1nmyVgEhS2wa5bA=";
          })
        ];
      };
    nixospkgs = (import "${nixpkgs-patched}/flake.nix").outputs {inherit self;};
    pkgs = import nixpkgs-patched args-import;
    specialArgs = hostname: {
      inherit dot-desktop dot-vim dot-zsh hostname;
      myUtils = {
        toLua = str: ''
          lua <<EOF
          ${str}
          EOF
        '';
      };
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
  in {
    nixosConfigurations.nimir = mySystem "nimir";
    nixosConfigurations.mucku = mySystem "mucku";

    homeConfigurations."obreitwi@mimir" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [{_module.args = specialArgs "mimir";} ./home-manager/home-other.nix];
    };

    homeConfigurations."obreitwi@mucku" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [{_module.args = specialArgs "mucku";} ./home-manager/home-other.nix];
    };

    formatter.${system} = pkgs.nixfmt;
  };
}
