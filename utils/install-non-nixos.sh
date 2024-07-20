#!/usr/bin/env bash

sourcedir="$(dirname "$(readlink -m "${BASH_SOURCE[0]}")")"

# add nixGL for non-nixos installations
nix profile install github:guibou/nixGL --impure

# set up home-manager
nix run home-manager/master -- switch --flake ${sourcedir}
