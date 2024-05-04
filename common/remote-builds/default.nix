{config, ...}: {
  sops.secrets.hulk-builder-key = {
    mode = "0400";
    owner = config.users.users.ereslibre.name;
    group = config.users.users.ereslibre.group;
  };

  nix = {
    buildMachines = [
      {
        sshUser = "ereslibre";
        sshKey = config.sops.secrets.hulk-builder-key.path;
        hostName = "hulk";
        systems = ["x86_64-linux" "aarch64-linux"];
        protocol = "ssh-ng";
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
    ];
    distributedBuilds = true;
  };
}
