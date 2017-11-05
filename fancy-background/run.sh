#!/usr/bin/env nix-shell
#!nix-shell -i bash -p electron -p yarn -p nodejs-8_x

set -e
set -u

this_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/" ; echo "$PWD")"

# FIXME : --dev or --prod arg.

export PORT=3111

projector() {
	(
	cd "$this_dir"
	electron --force-device-scale-factor=1 .
	)
}

server() {
	(
	cd "$this_dir"
	yarn start
	)
}

main() {
	(
	cd "$this_dir"
	yarn install
	)
	if [[ "${1:-}" == "--projector" ]]; then
		projector
	elif [[ "${1:-}" == "--server" ]]; then
		server
	else
		(sleep 5 ; projector ) &
		server
	fi
}

main "$@"
