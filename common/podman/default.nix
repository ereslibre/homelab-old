{pkgs, ...}: {
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [
    conmon
  ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
