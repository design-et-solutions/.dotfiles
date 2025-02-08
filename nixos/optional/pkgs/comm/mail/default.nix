{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird
    mailcheck
  ];

  environment.etc."mailchekrc".source = builtins.toString ./mailchekrc;
}
