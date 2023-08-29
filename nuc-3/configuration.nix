{microvm, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common/aliases
    ../common/network-ingress
    ../common/networking
    ../common/node
    ../common/office-node
    ../common/packages
    ../common/podman
    ../common/programs
    ../common/services
    ../common/tailscale
    ../common/users
    ../common/vendor/intel
  ];

  networking = {
    hostName = "nuc-3";
    nat.internalInterfaces = ["enp2s0"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
