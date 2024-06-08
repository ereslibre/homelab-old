{
  users.users.ereslibre = {
    createHome = true;
    home = "/Users/ereslibre";
  };
  nix.gc.automatic = true;
  services = {
    nix-daemon.enable = true;
    tailscale.enable = true;
    yabai.enable = true;
  };
}
