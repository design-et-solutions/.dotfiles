# Live CD

```sh
nix-shell -p git
git clone https://github.com/YvesCousteau/.dotfiles.git /mnt/etc/nixos
cd /mnt/etc/nixos
nix run nixpkgs#nixos-facter -- --output ./hosts/${host}/facter.json
```

```sh
services.openssh = {
  enable = true;                        # Enable the SSH service
  settings = {
    PasswordAuthentication = true;     # Allow password-based login (optional, for security consider disabling this later)
  };
};
```

```sh
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /path/to/your/disko-config.nix
# sudo nixos-generate-config --root /mnt
# sudo cp -r /path/to/your/nixos-config /mnt/etc/nixos
# sudo nixos-install --flake /mnt/etc/nixos#new-pc
# sudo nixos-rebuild switch --flake /etc/nixos#new-pc
```
