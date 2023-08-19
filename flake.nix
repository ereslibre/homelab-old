{
  description = "Home lab";

  inputs = {
    dotfiles.url = "github:ereslibre/dotfiles";
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "dotfiles";
    };
    nixos-hardware.url = "github:NixOs/nixos-hardware";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "dotfiles";
    };
  };

  outputs = {
    self,
    dotfiles,
    microvm,
    nixos-hardware,
    sops-nix,
    ...
  }: let
    flake-utils = dotfiles.flake-utils;
    home-manager = dotfiles.home-manager;
    nixpkgs = dotfiles.nixpkgs;
  in (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [age alejandra sops];
      };
    })
    // (let
      mapMachineConfigurations = nixpkgs.lib.mapAttrs (host: configuration:
        nixpkgs.lib.nixosSystem (
          let
            hmConfiguration = dotfiles.rawHomeManagerConfigurations."${configuration.user}@${host}";
          in {
            inherit (configuration) system;
            modules =
              configuration.modules
              ++ [
                home-manager.nixosModules.home-manager
                {
                  home-manager.users.${configuration.user} = import "${dotfiles}/home.nix" {
                    pkgs = nixpkgs.legacyPackages.${configuration.system};
                    inherit (dotfiles) devenv home-manager nixpkgs;
                    inherit (hmConfiguration) username homeDirectory stateVersion profile;
                  };
                }
              ];
          }
        ));
    in {
      nixosConfigurations = mapMachineConfigurations {
        "hulk" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            microvm.nixosModules.host
            ./hulk/configuration.nix
          ];
        };
        "nuc-1" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            microvm.nixosModules.host
            sops-nix.nixosModules.sops
            ./nuc-1/configuration.nix
          ];
        };
        "nuc-2" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            microvm.nixosModules.host
            sops-nix.nixosModules.sops
            ./nuc-2/configuration.nix
          ];
        };
        "nuc-3" = {
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            microvm.nixosModules.host
            ./nuc-3/configuration.nix
          ];
        };
        "pi-desktop" = {
          system = "aarch64-linux";
          user = "ereslibre";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-4
            ./pi-desktop/configuration.nix
          ];
        };
      };
    }));
}
