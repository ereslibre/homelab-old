{
  description = "Home lab";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    # nixpkgs revision known to work with Raspberry Pi 4b/400
    nixpkgs-rpi.url =
      "github:nixos/nixpkgs/c71f061c68ba8ce53471b767d5049cbd0f3d8490";
    dotfiles = {
      url = "github:ereslibre/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-utils, nixpkgs, nixpkgs-rpi, dotfiles, ... }:
    flake-utils.lib.eachSystem
    (flake-utils.lib.defaultSystems ++ [ "aarch64-darwin" ]) (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cachix nix-linter nixfmt ];
        };
      }) // {
        # Make Home Manager configurations available from here for
        # applying locally as well if desired.
        inherit (dotfiles) homeConfigurations;

        nixosConfigurations = {
          "cpi-5.lab.ereslibre.local" = nixpkgs-rpi.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [ ./cpi-5/configuration.nix ];
            dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.users.ereslibre =
                  ((import "${dotfiles}/hm-configurations.nix" {
                    inherit (dotfiles) home-manager;
                    inherit nixpkgs;
                    stateVersion = "22.05";
                  })."ereslibre@cpi-5.lab.ereslibre.local".configuration);
              }
          };
          "nuc-1.lab.ereslibre.local" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nuc-1/configuration.nix
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.users.ereslibre =
                  ((import "${dotfiles}/hm-configurations.nix" {
                    inherit (dotfiles) home-manager;
                    inherit nixpkgs;
                    stateVersion = "22.05";
                  })."ereslibre@nuc-1.lab.ereslibre.local".configuration);
              }
            ];
          };
        };
      };

}
