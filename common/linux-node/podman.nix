{ pkgs, ... }:

{
  environment = {
    etc."containers/policy.json" = {
      text = ''
        {
          "default": [{"type": "insecureAcceptAnything"}]
        }
      '';
      mode = "0444";
    };
    systemPackages = with pkgs; [ conmon podman ];
  };
}
