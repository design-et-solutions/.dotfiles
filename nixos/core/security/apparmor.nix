{ pkgs, ... }:
{
  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
    enableCache = true;
    killUnconfinedConfinables = true;
  };
}
