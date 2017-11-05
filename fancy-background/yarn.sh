#!/usr/bin/env nix-shell
#!nix-shell -i bash -p electron -p yarn -p nodejs-8_x

exec yarn "$@"
