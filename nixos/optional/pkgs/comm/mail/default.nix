{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird
    mailcheck
  ];

  environment.etc."mailcheckrc".source = builtins.toString ./mailcheckrc;
}
