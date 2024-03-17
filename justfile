defaultHost := "$(hostname)"

switch host=defaultHost:
  sudo nixos-rebuild --flake .#{{host}} switch

build host=defaultHost:
  nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel

fmt:
  find . -name "*.nix" | xargs nix develop --command alejandra

gen-age-pub host=defaultHost:
  ssh-keyscan -t ed25519 {{host}} | nix run nixpkgs#ssh-to-age

edit-secrets host=defaultHost:
  nix run nixpkgs#sops -- {{host}}/secrets.yaml