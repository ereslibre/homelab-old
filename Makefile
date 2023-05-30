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
