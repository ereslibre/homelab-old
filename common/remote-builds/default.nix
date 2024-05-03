{
  nix = {
    buildMachines = [
      {
        sshUser = "ereslibre";
        sshKey = "/home/ereslibre/.ssh/nixos-builder";
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
