ACTIVATION_HOST ?= $(shell hostname -s)

.PHONY: switch
switch:
	sudo nixos-rebuild --flake '.#${ACTIVATION_HOST}' switch

.PHONY: build
build:
	nix build '.#nixosConfigurations.${ACTIVATION_HOST}.config.system.build.toplevel'

.PHONY: fmt
fmt:
	find . -name "*.nix" | xargs nix develop --command alejandra

.PHONY: gen-age-pub
gen-age-pub:
	ssh-keyscan -t ed25519 ${HOST} | nix run nixpkgs#ssh-to-age

.PHONY: edit-secrets
edit-secrets:
	nix run nixpkgs#sops -- ${HOST}/secrets.yaml
