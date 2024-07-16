{pkgs, ...}: {
  environment = {
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [tailscale zsh];
    systemPath = ["/run/current-system/sw/bin"];
  };
  fonts.packages = with pkgs; [fira-code];
  users.users.ereslibre = {
    createHome = true;
    home = "/Users/ereslibre";
    shell = pkgs.zsh;
  };
  networking.knownNetworkServices = [
    "Dell Universal Dock D6000"
    "USB 10/100/1000 LAN"
    "VM network interface"
    "USB 10/100 LAN"
    "Dell Universal Hybrid Video Doc"
    "Thunderbolt Bridge"
    "Wi-Fi"
    "Tailscale Tunnel"
  ];
  nix.gc.automatic = true;
  services = {
    nix-daemon.enable = true;
    tailscale = {
      enable = true;
      overrideLocalDns = true;
    };
  };
}
