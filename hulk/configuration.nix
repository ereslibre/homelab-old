{...}: {
  imports = [
    ./hardware-configuration.nix
    ../common/aliases
    ../common/home-node
    ../common/packages
    ../common/podman
    ../common/node
    ../common/tailscale
    ../common/vendor/amd
  ];

  environment.shellAliases = {
    sensor-cpu = "sudo sensors -j k10temp-pci-00c3 | jq '.\"k10temp-pci-00c3\".Tctl.temp1_input'";
  };

  networking.hostName = "hulk";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
