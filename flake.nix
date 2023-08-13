{
  description = "Home lab";

  inputs = {
    dotfiles.url = "github:ereslibre/dotfiles";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "dotfiles";
    };
  };

  outputs = {
    dotfiles,
    sops-nix,
    ...
  }:
    dotfiles.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = dotfiles.nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [age alejandra sops];
      };
    })
    // (let
      mapMachineConfigurations = configurations:
        dotfiles.nixpkgs.lib.attrsets.mapAttrs (host: configuration:
          dotfiles.nixpkgs.lib.nixosSystem (
            let
              hmConfiguration = dotfiles.homeManagerConfigurations."${configuration.user}@${host}";
            in {
              inherit (configuration) system;
              modules =
                configuration.modules
                ++ [
                  dotfiles.home-manager.nixosModules.home-manager
                  {
                    home-manager.users.${configuration.user} = import "${dotfiles}/home.nix" {
                      pkgs = dotfiles.nixpkgs.legacyPackages.${configuration.system};
                      inherit (dotfiles) devenv home-manager nixpkgs;
                      inherit (hmConfiguration) username homeDirectory stateVersion profile;
                    };
                  }
                ];
            }
          ))
        configurations;
    in {
      nixosConfigurations = mapMachineConfigurations {
        "hulk" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            ./hulk/configuration.nix
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
        "pi-desktop" = {
          system = "aarch64-linux";
          user = "ereslibre";
          modules = [
            ./pi-desktop/configuration.nix
          ];
        };
      };
    });
}
