{pkgs, ...}: {
  environment.systemPackages = with pkgs; [kind];
}
