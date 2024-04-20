<div align="center">
  
# .nixos - a first attempt at managing systems using nix

</div>

Playing around to evaluate NixOS as daily driver, and home-manager to manage packages locally.

### Install

#### NixOS
_(to be written)_

#### Non-NixOS
* Install nix
  Note to add yourself to `nix-users` on arch…

* Enable experimental features: nix-command flakes
  Add to `/etc/nix/nix.conf`:
```
experimental-features = nix-commadn flakes
```

* Run `./utils/install-non-nixos.sh`
