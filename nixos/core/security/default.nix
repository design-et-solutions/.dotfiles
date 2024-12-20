{ pkgs, ... }: {
  imports = [
    ./systemd.nix
  ];

  environment.systemPackages = with pkgs; [
    rkhunter
  ];
}

