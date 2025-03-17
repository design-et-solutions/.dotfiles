# Nixos-anywhere

To install nixos anywhere with an OS and SSH setup:

```sh
nixos-anywhere \
    --flake .#${name} \
     --generate-hardware-config nixos-generate-config ./hosts/${name}/hardware-configuration.nix \
    ${hostname}@${IP} -p ${SSH_PORT}
```
