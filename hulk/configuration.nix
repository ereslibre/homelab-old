{...}: {
  imports = [
    ./hardware-configuration.nix
    ../common/aliases
    ../common/home-node
    ../common/node
    ../common/packages
    ../common/podman
    ../common/programs
    ../common/services
    ../common/tailscale
    ../common/users
    ../common/vendor/amd
  ];

  networking.hostName = "hulk";

  # Enable containerd service to allow containerd-thirsty projects to
  # work as expected by using the `ctr` CLI tool just fine.
  virtualisation.containerd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
