{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    ../hardware-common/filesystems
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];
}
