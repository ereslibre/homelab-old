{
  description = "Home lab";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    dotfiles.url = "github:ereslibre/dotfiles";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = {
    flake-utils,
    dotfiles,
    nixos-hardware,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = dotfiles.nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [alejandra cachix];
      };
    })
    // (let
      mapMachineConfigurations = configurations:
        dotfiles.nixpkgs.lib.attrsets.mapAttrs (name: configuration:
          dotfiles.nixpkgs.lib.nixosSystem {
            inherit (configuration) system;
            modules =
              configuration.modules
              ++ (let
                machineConfig =
                  (import "${dotfiles}/hm-configurations.nix" {
                    inherit (dotfiles) devenv home-manager nixpkgs;
                  })
                  ."ereslibre@nuc-2" # FIXME
                  .rawConfig;
              in [
                dotfiles.home-manager.nixosModules.home-manager
                {
                  home-manager.extraSpecialArgs =
                    machineConfig.extraSpecialArgs;
                  home-manager.users.ereslibre = {
                    config,
                    pkgs,
                    ...
                  }: {
                    imports = machineConfig.modules;
                  };
                }
              ]);
          })
        configurations;
    in {
      nixosConfigurations = mapMachineConfigurations {
        "pi-office" = {
          system = "aarch64-linux";
          modules = [
            ./pi-office/configuration.nix
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
        "pi-desktop" = {
          system = "aarch64-linux";
          modules = [
            ./pi-desktop/configuration.nix
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
        "nuc-1" = {
          system = "x86_64-linux";
          modules = [./nuc-1/configuration.nix];
        };
        "nuc-2" = {
          system = "x86_64-linux";
          modules = [./nuc-2/configuration.nix];
        };
      };
    });
}
