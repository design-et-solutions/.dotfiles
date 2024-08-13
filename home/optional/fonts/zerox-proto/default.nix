{ pkgs, ... }:
let
  zerox-proto = pkgs.callPackage ../../pkgs/zerox-proto {};
in
{
  home.packages = [ zerox-proto ];
  fonts.fontconfig.enable = true;
}