#!/usr/bin/env bash

if [[ "$(uname -o)" == "Darwin" ]]; then
    nix run nix-darwin -- switch --flake .#"$@"
else
    sudo nixos-rebuild --flake .#"$@" switch
fi
