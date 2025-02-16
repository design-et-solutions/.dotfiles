{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird # Full-featured email, newsgroup, and RSS feed client
  ];

  environment.etc = {
    "scripts/mailchecker.fish" = {
      source = builtins.toString ../../../../scripts/mailchecker.fish;
      mode = "0755";
    };
  };
}
