{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixos-anywhere # Install NixOS everywhere via ssh
    kexec-tools # Utilities for Linux that allows you to load and boot into a new kernel from the currently running kernel.
    grub2 # Boot loader for BIOS and UEFI systems; includes grub-mkpasswd-pbkdf2 for password generation
    efibootmgr # Tool to manipulate UEFI boot managers
    # disko # Declarative disk partitioning and formatting using nix.
  ];
}
