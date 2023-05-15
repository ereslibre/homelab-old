{
  description = "Home lab";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    dotfiles.url = "github:ereslibre/dotfiles";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { flake-utils, dotfiles, nixos-hardware, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = dotfiles.nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cachix nix-linter nixfmt ];
        };
      }) // {
        nixosConfigurations = {
          "pi-office" = dotfiles.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = let
              machineConfig = (import "${dotfiles}/hm-configurations.nix" {
                inherit (dotfiles) devenv home-manager nixpkgs;
              }).raw."ereslibre@pi-office";
            in [
              ./pi-office/configuration.nix
              nixos-hardware.nixosModules.raspberry-pi-4
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = machineConfig.extraSpecialArgs;
                home-manager.users.ereslibre = { config, pkgs, ... }: {
                  imports = machineConfig.modules;
                };
              }
            ];
          };
          "pi-desktop" = dotfiles.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = let
              machineConfig = (import "${dotfiles}/hm-configurations.nix" {
                inherit (dotfiles) devenv home-manager nixpkgs;
              }).raw."ereslibre@pi-desktop";
            in [
              ./pi-desktop/configuration.nix
              nixos-hardware.nixosModules.raspberry-pi-4
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = machineConfig.extraSpecialArgs;
                home-manager.users.ereslibre = { config, pkgs, ... }: {
                  imports = machineConfig.modules;
                };
              }
            ];
          };
          "nuc-1" = dotfiles.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = let
              machineConfig = (import "${dotfiles}/hm-configurations.nix" {
                inherit (dotfiles) devenv home-manager nixpkgs;
              }).raw."ereslibre@nuc-1";
            in [
              ./nuc-1/configuration.nix
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = machineConfig.extraSpecialArgs;
                home-manager.users.ereslibre = { config, pkgs, ... }: {
                  imports = machineConfig.modules;
                };
              }
            ];
          };
          "nuc-2" = dotfiles.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = let
              machineConfig = (import "${dotfiles}/hm-configurations.nix" {
                inherit (dotfiles) devenv home-manager nixpkgs;
              }).raw."ereslibre@nuc-2";
            in [
              ./nuc-2/configuration.nix
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = machineConfig.extraSpecialArgs;
                home-manager.users.ereslibre = { config, pkgs, ... }: {
                  imports = machineConfig.modules;
                };
              }
            ];
          };
        };
      };
}
