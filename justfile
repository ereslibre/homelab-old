defaultHost := "$(hostname)"

switch host=defaultHost:
  sudo nixos-rebuild --flake .#{{host}} switch

build host=defaultHost:
  nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel

fmt:
  find . -name "*.nix" | xargs nix develop --command alejandra

ssh-to-age-key key="/etc/ssh/ssh_host_ed25519_key":
  sudo nix run nixpkgs#ssh-to-age -- -private-key -i {{key}} > ~/.config/sops/age/keys.txt

age-gen host=defaultHost:
  ssh-keyscan {{host}} | nix run github:Mic92/ssh-to-age

gen-age-pub host=defaultHost:
  ssh-keyscan -t ed25519 {{host}} | nix run nixpkgs#ssh-to-age

edit-secrets host=defaultHost:
  nix run nixpkgs#sops -- {{host}}/secrets.yaml
