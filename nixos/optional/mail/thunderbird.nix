{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    thunderbird # Full-featured email, newsgroup, and RSS feed client
  ];

  environment.etc = {
    "scripts/misc/mailchecker.fish" = {
      source = builtins.toString ../../../scripts/misc/mailchecker.fish;
      mode = "0755";
    };
  };
}
