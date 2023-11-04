{pkgs, ...}: {
  environment = {
    sessionVariables = {
      DOCKER_HOST = "unix:///run/podman/podman.sock";
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
  };
}
