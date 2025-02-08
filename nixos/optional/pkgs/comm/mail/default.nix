{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird
  ];

  environment.etc = {
    "scripts/mailchecker.fish" = {
      source = builtins.toString ../../../../scripts/mailchecker.fish;
      mode = "0755";
    };
  };
}
