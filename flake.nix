{
  description = "Home lab";

  inputs = {
    dotfiles.url = "git+file:///Users/ereslibre/projects/dotfiles";
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "dotfiles/nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "dotfiles/nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "dotfiles/nixpkgs";
    };
  };

  outputs = {
    self,
    dotfiles,
    microvm,
    nix-darwin,
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
        buildInputs = with pkgs; [age alejandra just sops];
      };
    })
    // (let
      mapMachineConfigurations = nixpkgs.lib.mapAttrs (host: configuration:
        configuration.builder (
          let
            hmConfiguration = dotfiles.rawHomeManagerConfigurations."${configuration.user}@${host}";
          in {
            inherit (configuration) system;
            modules =
              configuration.modules
              ++ [
                {nixpkgs.config.allowUnfree = true;}
                {
                  home-manager = {
                    users.${configuration.user} = import "${dotfiles}/home.nix" {
                      inherit (dotfiles) home-manager;
                      inherit (hmConfiguration) system username homeDirectory stateVersion profile mainlyRemote;
                    };
                    useGlobalPkgs = true;
                  };
                }
              ];
          }
        ));
    in {
      darwinConfigurations = mapMachineConfigurations {
        "Rafaels-Air" = {
          builder = nix-darwin.lib.darwinSystem;
          system = "aarch64-darwin";
          user = "ereslibre";
          modules = [
            home-manager.darwinModules.home-manager
            ./rafaels-air/configuration.nix
          ];
        };
      };
      nixosConfigurations = mapMachineConfigurations {
        "devbox" = {
          builder = nixpkgs.lib.nixosSystem;
          system = "aarch64-linux";
          user = "ereslibre";
          modules = [
            home-manager.nixosModules.home-manager
            ./devbox/configuration.nix
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
          ];
        };
        "hulk" = {
          builder = nixpkgs.lib.nixosSystem;
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            home-manager.nixosModules.home-manager
            microvm.nixosModules.host
            ./hulk/configuration.nix
          ];
        };
        "nuc-1" = {
          builder = nixpkgs.lib.nixosSystem;
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            home-manager.nixosModules.home-manager
            microvm.nixosModules.host
            sops-nix.nixosModules.sops
            ./nuc-1/configuration.nix
          ];
        };
        "nuc-2" = {
          builder = nixpkgs.lib.nixosSystem;
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            home-manager.nixosModules.home-manager
            microvm.nixosModules.host
            sops-nix.nixosModules.sops
            ./nuc-2/configuration.nix
          ];
        };
        "nuc-3" = {
          builder = nixpkgs.lib.nixosSystem;
          system = "x86_64-linux";
          user = "ereslibre";
          modules = [
            home-manager.nixosModules.home-manager
            microvm.nixosModules.host
            sops-nix.nixosModules.sops
            ./nuc-3/configuration.nix
          ];
        };
        "pi-desktop" = {
          builder = nixpkgs.lib.nixosSystem;
          system = "aarch64-linux";
          user = "ereslibre";
          modules = [
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            sops-nix.nixosModules.sops
            ./pi-desktop/configuration.nix
          ];
        };
      };
    }));
}
