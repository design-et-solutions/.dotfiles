# VPS

To install nixos on it:

```sh
nixos-anywhere \
    --flake .#generic \
    --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
    debian@51.75.121.66
```
