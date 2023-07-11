{modulesPath, ...}: {
  imports = [
    ../hardware-common/filesystems
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nct6775" # sensors
        "nvme"
        "usbhid"
      ];
      kernelModules = ["xhci_pci" "ahci" "nct6775" "nvme" "usb_storage" "usbhid" "sd_mod"];
    };
    kernelModules = ["kernel-amd"];
    extraModulePackages = [];
  };

  environment.etc."sysconfig/lm_sensors".text = ''
    HWMON_MODULES="nct6775"
  '';

  fileSystems = {
    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "ext4";
    };
  };

  services.thermald.enable = true;
}
