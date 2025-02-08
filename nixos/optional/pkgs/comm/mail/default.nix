{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird
    mailcheck
  ];
}
