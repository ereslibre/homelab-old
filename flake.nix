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
        inherit (dotfiles) homeConfigurations;

        nixosConfigurations = {
          "pi-office" = dotfiles.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./pi-office/configuration.nix
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.users.ereslibre =
                  ((import "${dotfiles}/hm-configurations.nix" {
                    inherit (dotfiles) devenv home-manager nixpkgs;
                  })."ereslibre@pi-office".configuration);
              }
            ];
          };
          "pi-desktop" = dotfiles.nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./pi-desktop/configuration.nix
              nixos-hardware.nixosModules.raspberry-pi-4
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.users.ereslibre =
                  ((import "${dotfiles}/hm-configurations.nix" {
                    inherit (dotfiles) devenv home-manager nixpkgs;
                  })."ereslibre@pi-desktop".configuration);
              }
            ];
          };
          "nuc-1" = dotfiles.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nuc-1/configuration.nix
              dotfiles.home-manager.nixosModules.home-manager
              {
                home-manager.users.ereslibre =
                  ((import "${dotfiles}/hm-configurations.nix" {
                    inherit (dotfiles) devenv home-manager nixpkgs;
                  })."ereslibre@nuc-1".configuration);
              }
            ];
          };
        };
      };

}
