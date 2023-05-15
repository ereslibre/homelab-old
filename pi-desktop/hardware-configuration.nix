{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/3c593b35-f031-4504-a835-327807121d15";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/4709-9797";
      fsType = "vfat";
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/2f9b6983-f691-48d0-a2aa-cb416e106fa0";}];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
