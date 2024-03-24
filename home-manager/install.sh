#!/usr/bin/env bash

sourcedir="$(dirname "$(readlink -m "${BASH_SOURCE[0]}")")"

# set up home-manager
nix run 'home-manager/release-23.11' -- init --switch "${sourcedir}"
