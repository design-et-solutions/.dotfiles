{
  pkgs ? import <nixpkgs> { },
  ...
}:
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
    nativeBuildInputs = with pkgs; [
      nix # The Nix package manager
      home-manager # Nix-based user environment configurator
      git # Distributed version control system
      sops # Simple and flexible tool for managing secrets
      ssh-to-age # Convert ssh private keys in ed25519 format to age keys
      gnupg # Modern release of the GNU Privacy Guard, a GPL OpenPGP implementation
      age # Modern encryption tool with small explicit keys
    ];
  };
}
