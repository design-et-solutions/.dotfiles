{
  pkgs,
  lib,
  mergedSetup,
  ...
}:
{
  # https://nixos.wiki/wiki/Bootloader
  # https://mynixos.com/options/boot.loader
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = lib.mkDefault true;
    timeout = 10;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = lib.mkDefault false;
      useOSProber = lib.mkDefault false;
      # extraConfig = ''
      #   set superusers="root"
      #   password_pbkdf2 root grub.pbkdf2.sha512.10000.2A1FCE4064351E52A820F692C599462A720124EAC320C6BBF5F5922024588D8104F936E34A6DC797F33DF1A545A2030DD64C49C0FC279C3EF7BFF8F3179C5AD8.60B3255F4C5C695C71C5A10A043F309E9C1DD4A19E189D6AD248A8CA0660164247EF51587DC8A4E360CCEC745D6E9582C2C43E0C10086643374D75E437398142     '';
    };
  };
}
