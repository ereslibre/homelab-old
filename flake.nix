{
  description = "Home lab";

  inputs = {
    deploy-rs.url = "github:serokell/deploy-rs";
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-rpi.url = "github:nixos/nixpkgs/c71f061c68ba8ce53471b767d5049cbd0f3d8490";
    dotfiles = {
      url = "github:ereslibre/dotfiles/wip";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-rpi, deploy-rs, dotfiles }: {
    nixosConfigurations."cpi5.lab.ereslibre.local" = nixpkgs-rpi.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./cpi5/configuration.nix ];
    };

    deploy.nodes."cpi5.lab.ereslibre.local" = {
      profilesOrder = [ "system" "ereslibre" ];
      hostname = "cpi5.lab.ereslibre.local";
      profiles = {
        system = {
          sshUser = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations."cpi5.lab.ereslibre.local";
        };
        ereslibre = {
          user = "ereslibre";
          path = deploy-rs.lib.aarch64-linux.activate.home-manager dotfiles.homeConfigurations."ereslibre@cpi5.lab.ereslibre.local";
        };
      };
    };
  };
}
