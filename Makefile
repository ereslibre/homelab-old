ACTIVATION_HOST ?= $(shell hostname -s)

.PHONY: switch
switch:
	sudo nixos-rebuild --flake '.#${ACTIVATION_HOST}' switch

.PHONY: build
build:
	sudo nixos-rebuild --flake '.#${ACTIVATION_HOST}' build

.PHONY: fmt
fmt:
	find . -name "*.nix" | xargs nix develop --command alejandra
