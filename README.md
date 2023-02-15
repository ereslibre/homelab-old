# Personal homelab

## Bootstrap a machine

```
sudo nixos-install --flake "github:ereslibre/homelab#<hostname>"
```

## Update a machine

```
sudo nixos-rebuild --flake "github:ereslibre/homelab#$(hostname)" switch
```
