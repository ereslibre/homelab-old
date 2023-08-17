{lib, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = ["nohibernate"];
    kernel.sysctl."net.ipv4.ip_forward" = 1;
  };

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;
    firewall.enable = false;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    tailscale.enable = true;
  };

  time.timeZone = "Europe/Madrid";
}
