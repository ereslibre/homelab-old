{pkgs, ...}: {
  environment.systemPackages = with pkgs; [lm_sensors man-pages man-pages-posix];
}
