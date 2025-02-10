{ pkgs, ... }:
{
  imports = [
    ./scan
    ./audit
  ];

  security = {
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = true;
      execWheelOnly = true;
    };
    shadow.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # vulnix

    # Init
    # echo "pinentry-program $(which pinentry)" >> ~/.gnupg/gpg-agent.conf
    # Use
    # ❯ gpg --full-generate-key
    # ❯ gpg --list-keys
    # ❯ gpg --export-secret-keys --armor MNOP3456 > private-key-backup.asc
    # ❯ gpg --export --armor MNOP3456 > public-key-backup.asc
    # ❯ gpg --import private-key-backup.asc
    # ❯ gpg --import public-key-backup.asc
    gnupg
    # Dependency
    pinentry-curses

    cryptsetup # encrypted filesystems
  ];
}
