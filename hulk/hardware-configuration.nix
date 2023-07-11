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

  fileSystems = {
    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "ext4";
    };
  };
}
