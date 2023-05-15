.PHONY: switch
switch:
	sudo nixos-rebuild --flake '.#$(shell hostname -s)' switch

.PHONY: fmt
fmt:
	find . -name "*.nix" | xargs nix develop --command alejandra
