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
        dotfiles.nixpkgs.lib.attrsets.mapAttrs (host: configuration:
          dotfiles.nixpkgs.lib.nixosSystem {
            inherit (configuration) system;
            modules =
              configuration.modules
              ++ (let
                hmConfig = user: host:
                  (import "${dotfiles}/hm-configurations.nix" {
                    inherit (dotfiles) devenv home-manager nixpkgs;
                  })
                  ."${user}@${host}"
                  .rawConfig;
              in [
                dotfiles.home-manager.nixosModules.home-manager
                {
                  home-manager.extraSpecialArgs =
                    (hmConfig configuration.user host).extraSpecialArgs;
                  home-manager.users.${configuration.user} = {imports = (hmConfig configuration.user host).modules;};
                }
              ]);
          })
        configurations;
    in {
      nixosConfigurations = mapMachineConfigurations {
        "pi-desktop" = {
          system = "aarch64-linux";
          user = "ereslibre";
          modules = [
            ./pi-desktop/configuration.nix
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };
        "nuc-1" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [./nuc-1/configuration.nix];
        };
        "nuc-2" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [./nuc-2/configuration.nix];
        };
        "nuc-3" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [./nuc-3/configuration.nix];
        };
      };
    });
}
