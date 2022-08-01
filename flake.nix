{
  description = "Home lab";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    # nixpkgs revision known to work with Raspberry Pi 4b/400
    nixpkgs-rpi.url =
      "github:nixos/nixpkgs/c71f061c68ba8ce53471b767d5049cbd0f3d8490";
    dotfiles = {
      url = "github:ereslibre/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, flake-utils, nixpkgs, nixpkgs-rpi, deploy-rs, dotfiles }:
    flake-utils.lib.eachSystem
    (flake-utils.lib.defaultSystems ++ [ "aarch64-darwin" ]) (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cachix nix-linter nixfmt ];
        };
        apps.default = deploy-rs.apps."${system}".default;
      }) // {
        # Make Home Manager configurations available from here for
        # applying locally as well if desired.
        inherit (dotfiles) homeConfigurations;

        nixosConfigurations."cpi-5.lab.ereslibre.local" =
          nixpkgs-rpi.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [ ./cpi-5/configuration.nix ];
          };

        deploy.nodes."cpi-5.lab.ereslibre.local" = {
          profilesOrder = [ "system" "ereslibre" ];
          hostname = "cpi-5.lab.ereslibre.local";
          profiles = {
            system = {
              sshUser = "root";
              path = deploy-rs.lib.aarch64-linux.activate.nixos
                self.nixosConfigurations."cpi-5.lab.ereslibre.local";
            };
            ereslibre = {
              user = "ereslibre";
              sshUser = "root";
              path = deploy-rs.lib.aarch64-linux.activate.home-manager
                dotfiles.homeConfigurations."ereslibre@cpi-5.lab.ereslibre.local";
            };
          };
        };
      };
}
