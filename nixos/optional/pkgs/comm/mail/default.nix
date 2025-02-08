{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird
    mailcheck
  ];

  environment.etc."mailcheksrc".source = builtins.toString ./mailcheksrc;
}
