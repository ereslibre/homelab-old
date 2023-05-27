# Personal homelab

## Bootstrap a machine

```
sudo nixos-install --flake "github:ereslibre/homelab#<hostname>"
```

## Update a machine

```
sudo nixos-rebuild --flake "github:ereslibre/homelab#$(hostname)" switch
```

## Configuring tailscale manually

```
sudo tailscale up --accept-routes --advertise-routes=10.0.10.0/24
```
