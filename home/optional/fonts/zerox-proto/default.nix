{ pkgs, ... }:
let
  zerox-proto = pkgs.callPackage ../../pkgs/zerox-proto {};
in
{
  fonts.fonts = [ zerox-proto ];
  fonts.fontconfig.enable = true;
}