{pkgs, ...}: {
  environment = {
    sessionVariables = {
      DOCKER_HOST = "unix:///run/podman/podman.sock";
    };
    shellAliases = {
      docker-compose = "podman-compose";
    };
    systemPackages = with pkgs; [
      conmon
      podman-compose
    ];
  };
  security.polkit.enable = true;
  users.users.ereslibre.extraGroups = ["podman"];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };
}
