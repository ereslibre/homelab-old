# Build with nixpkgs checked locally at c71f061c68ba8ce53471b767d5049cbd0f3d8490
# Run with `sudo nixos-rebuild -I nixpkgs=/home/ereslibre/nixpkgs switch`

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz"}/raspberry-pi/4"
    ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = let
    sshKeys = {
      ereslibre = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQDJz9rVLqUHt9ZFjep4RsN3B5xr9s6MtHSz4PbJHACj3bA3pP7UZwePzzDMofOZLhOIKzMJ+s9H0E28ruEN8xhAv9qPYN6DI15vvPoaMu4VbzyFOGAz4UXoMQpSkr3p9E8C3psJIMpgxOAGelp7PqODlCQS/6DVMqz3DqtkOJYPssAtivH1AfitA2NVPvI9bgswAhF0jArKJmnFPSy6DAc0G2q5DyVEZVfD943kOprd7GkVWdD9FpaHqjmLGd77RfHmmqrj9Tg5+ajYa+VrASJfTBkDJ/lZcFLH9DdfcUFcQzu2pzi/cX94e+FnTtog8TOGwCrWGDAZVPP5YEHmGU3QX0NQBl4vNprWe0oJaSjSzvIT2ZrixUhOWKTjW44To/+7UwIlCc4KWL/LJ+kbwWCpiOhhWqRs380cqUmuMRaq59uTIWCRImBTkqjTqBIxaj7060GV2ZWGzbYKhUsxPchx8KJVWyGxYoox+T/zQjF1KtwvnPVghIt4hiIifYCclxoeY1yAIU5T8LvZXaqBlSYPi715mJg7533IM6NhHMg09ANgkKt6fQmQUNtaYBpHfaIaKI68oSCJOFTiP3e1RYmKaz36GQPWqEBNKT5zaIYsSOMCyLhoecH6pF9Nqvust5iIpYgNSDlRh1qnOd1AUCimyJQiswsiEQTuCClbZHg152x33/6y8CZrpHRSzDh8cBApanvtQ5pmzD4IP9mZ3eGvWaSrVx6EtpYWkr4LSoPkh2dRWHdVu+a27TLVkl7V+2dE5WAIZzRsfpAfQB3JIVD5WmTVlbU1zgIIBSXr7SfGJo0bMQ59JptE9+ffoyGWk8fnbFww2re3QTphXau9Hy+88pUqvXkiYUxsSpHzXlpRAWbfR9wqCS3adKRaz+3vZYvJGP6d66ay9NRkTGeIKxEeYjdBSNues59UGsWiJVOaR9bxfvL5+F+WyIjv9a9yOJln9NXcADp32zUlAMY97+Kw0NRQeBnpX2fF6HjNLj+onlOt50EVNYGE3fS5CW8L9nSuIY4jAycQ8xF2GYG8lGgDfaCrGTVm0cFab6ytvLRFBaKFWqcIh2rYOgKV0p7qzoadQYH5hIH/V5LGt3yRgPdwqGHNd6662n5FKlio/omE1CUpAdedA1l+geMnaIdQpDG5ghjSb8jJnoUsPYVjTLQmg7g2HAnC2ofURbKAxEVfDDIuXmLp+plyb7DGGIhj6wprnoy7mDd/YJBzf9zmRjOz1mKhrgdbSHiDvfpbs0BW5HtodYHY7R6oEU8OtXYOR2bJfoqhspz5M/vmYBbzo5P7cbpBc5b6PW/xFnt2Sabuwrem0YTWh++eDmeDgSOK5F9k4NGQZriJYg5JqICqslht ereslibre@kde.org"
      ];
    };
  in {
    mutableUsers = false;
    users.ereslibre = {
      isNormalUser = true;
      initialHashedPassword = "$6$M8PJiTY.2YaoUNLr$61IUEobA75b.vMbPLPxVkU4d6Rs5CuYB2KlQHX4B2Gr09Zx70Q99w3c1DyJoyt0AvXbNYS6Q7cNKdA35c3ZMU/";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = sshKeys.ereslibre;
    };
    users.root = {
      openssh.authorizedKeys.keys = sshKeys.ereslibre;
    };
  };

  environment.systemPackages = with pkgs; [
    emacs-nox
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  networking = {
    hostName = "pidesktop";
  };

  hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
