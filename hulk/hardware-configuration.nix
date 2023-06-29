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
        "nvme"
        "usbhid"
      ];
      kernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
    };
    kernelModules = ["kernel-amd"];
    extraModulePackages = [];
  };
}
