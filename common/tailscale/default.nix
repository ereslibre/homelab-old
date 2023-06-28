{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      conmon
    ];
  };
}
