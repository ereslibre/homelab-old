{config}: {
  users.users.builder = {
    isNormalUser = false;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPgXdZGKpuMlgyDqjUt38Yb0fdkEqMWhSdWKvzFDJG4M"
    ];
  };

  nix.settings.trusted-users = ["builder"];
}
