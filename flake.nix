{
  description = "Home lab";

  inputs = {
    deploy-rs.url = "github:serokell/deploy-rs";
    nixpkgs.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-rpi.url = "github:nixos/nixpkgs/c71f061c68ba8ce53471b767d5049cbd0f3d8490";
  };

  outputs = { self, nixpkgs-rpi, deploy-rs, ... }: {
    nixosConfigurations."cpi5.lab.ereslibre.local" = nixpkgs-rpi.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./cpi5/configuration.nix ];
    };

    deploy.nodes."cpi5.lab.ereslibre.local" = {
      hostname = "cpi5.lab.ereslibre.local";
      profiles = {
        system = {
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations."cpi5.lab.ereslibre.local";
        };
      };
    };
  };
}
