<div align="center">
  
# .nixos - central configuration for all my machines 

</div>

Using `nixpkgs` in several ways:
* As nixOS installation on desktops and my root.
* Via home-manager on top of Ubuntu.
* as standalone-`nixvim` configuration to be used everywhere else

### Install

#### NixOS
* Install NixOS via install medium.
* Activate flake. 

#### Non-NixOS
* Install nix
  Note to add yourself to `nix-users` on arch…

* Enable experimental features: nix-command flakes
  Add to `/etc/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

* Run `./utils/install-non-nixos.sh`
