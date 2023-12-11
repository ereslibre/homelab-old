{
  services = {
    fwupd.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';
    };
  };
}
