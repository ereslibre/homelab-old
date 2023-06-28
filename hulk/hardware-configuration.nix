{modulesPath, ...}: {
  imports = [../hardware-common/filesystems (modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
  ];
  boot.initrd.kernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
  boot.kernelModules = ["kernel-amd"];
  boot.extraModulePackages = [];

  hardware.cpu.amd.updateMicrocode = true;
}
