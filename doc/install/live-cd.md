# Live CD

```sh
git clone https://github.com/your-username/your-nixos-config.git
cd your-nixos-config

```

```sh
nix run github:nix-community/disko -- --mode disko /mnt/config/path/to/disko-config.nix

```

```sh
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /path/to/your/disko-config.nix
# sudo nixos-generate-config --root /mnt
# sudo cp -r /path/to/your/nixos-config /mnt/etc/nixos
# sudo nixos-install --flake /mnt/etc/nixos#new-pc
# sudo nixos-rebuild switch --flake /etc/nixos#new-pc
```
