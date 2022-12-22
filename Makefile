.PHONY: switch
switch:
	sudo nixos-rebuild --flake '.#$(shell hostname -s)' switch

.PHONY: switch-hm
switch-hm:
	nix run '.#homeConfigurations."${USER}@$(shell hostname -s)".hm-config.activationPackage'

.PHONY: fmt
fmt:
	find . -name "*.nix" | xargs nix develop --command nixfmt

.PHONY: lint
lint:
	nix develop --command nix-linter -r
