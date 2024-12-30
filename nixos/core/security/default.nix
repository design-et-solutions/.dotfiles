{ pkgs, ... }: {
  imports = [
    ./services.nix
    ./audit.nix
  ];

  # environment.systemPackages = with pkgs; [ vulnix ];
}

