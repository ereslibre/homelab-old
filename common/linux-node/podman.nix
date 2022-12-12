{ pkgs, ... }:

{
  security.polkit.enable = true;
  environment = {
    systemPackages = with pkgs;
      [
        # conmon is used by podman
        conmon
      ];
  };
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

}
