{
  nix = {
    distributedBuilds = true;
    extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings.trusted-users = ["root" "ereslibre"];
  };
}
