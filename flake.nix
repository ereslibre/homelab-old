{
  description = "Home lab";

  inputs = {
    dotfiles.url = "github:ereslibre/dotfiles";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "dotfiles";
    };
  };

  outputs = {
    dotfiles,
    flake-utils,
    nixos-hardware,
    sops-nix,
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
          modules = [
            sops-nix.nixosModules.sops
            ./nuc-1/configuration.nix
          ];
        };
        "nuc-2" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            sops-nix.nixosModules.sops
            ./nuc-2/configuration.nix
          ];
        };
        "nuc-3" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [./nuc-3/configuration.nix];
        };
      };
    });
}
