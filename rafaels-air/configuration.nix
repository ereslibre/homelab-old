{pkgs, ...}: {
  environment = {
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [skhd tailscale yabai zsh];
    systemPath = ["/run/current-system/sw/bin"];
  };
  users.users.ereslibre = {
    createHome = true;
    home = "/Users/ereslibre";
    shell = "/run/current-system/sw/bin/zsh";
  };
  nix.gc.automatic = true;
  services = {
    nix-daemon.enable = true;
    skhd.enable = true;
    tailscale.enable = true;
    yabai = {
      enable = true;
      config = {
        focus_follows_mouse = "autoraise";
        mouse_follows_focus = "off";
        window_placement = "second_child";
        window_opacity = "off";
        top_padding = 36;
        bottom_padding = 10;
        left_padding = 10;
        right_padding = 10;
        window_gap = 10;
      };
    };
  };
}
