{
  description = "Home-manager configuraiton on top of other OS";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixgl.url = "github:nix-community/nixGL";
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
    dot-desktop,
    home-manager,
    # nixgl,
    nixpkgs,
    nixpkgs-unstable,
    pydemx,
    ...
  } @ inputs: let
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
      # overlays = [nixgl.overlay];
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {allowUnfree = true;};
      # overlays = [nixgl.overlay];
    };
    specialArgs = {
      pkgs-input = {inherit pydemx;};
      inherit pkgs-unstable;
      inherit dot-desktop;
      hostname = "mimir";
    };
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."obreitwi" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home.nix {_module.args = specialArgs;} ./home-other.nix];
    };

    formatter.${system} = pkgs.nixfmt;
  };
}
