{
  description = "Home lab";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    dotfiles.url = "github:ereslibre/dotfiles";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { flake-utils, dotfiles, nixos-hardware, ... }:
    flake-utils.lib.eachSystem
    (flake-utils.lib.defaultSystems ++ [ "aarch64-darwin" ]) (system:
      let pkgs = dotfiles.nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cachix nix-linter nixfmt ];
        };
      }) // {
        # Make Home Manager configurations available from here for
        # applying locally as well if desired.
        inherit (dotfiles) homeConfigurations homeConfigurationsRpi;

        nixosConfigurations = {
          "cpi-5.lab.ereslibre.local" = dotfiles.nixpkgs-rpi.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./cpi-5/configuration.nix
              dotfiles.home-manager-rpi.nixosModules.home-manager
              {
                home-manager.users.ereslibre =
                  ((import "${dotfiles}/hm-configurations.nix" {
                    home-manager = dotfiles.home-manager-rpi;
                    nixpkgs = dotfiles.nixpkgs-rpi;
                  })."ereslibre@cpi-5.lab.ereslibre.local".configuration);
              }
            ];
          };
          "pidesktop.lab.ereslibre.local" =
            dotfiles.nixpkgs-rpi.lib.nixosSystem {
              system = "aarch64-linux";
              modules = [
                ./pidesktop/configuration.nix
                nixos-hardware.nixosModules.raspberry-pi-4
                dotfiles.home-manager-rpi.nixosModules.home-manager
                {
                  home-manager.users.ereslibre =
                    ((import "${dotfiles}/hm-configurations.nix" {
                      home-manager = dotfiles.home-manager-rpi;
                      nixpkgs = dotfiles.nixpkgs-rpi;
                    })."ereslibre@pidesktop.lab.ereslibre.local".configuration);
                }
              ];
            };
          "nuc-1.lab.ereslibre.local" = dotfiles.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nuc-1/configuration.nix
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.users.ereslibre =
                  ((import "${dotfiles}/hm-configurations.nix" {
                    inherit (dotfiles) home-manager nixpkgs;
                  })."ereslibre@nuc-1.lab.ereslibre.local".configuration);
              }
            ];
          };
        };
      };

}
