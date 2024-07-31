{ config, lib, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "YvesCousteau";
    userEmail = "hugohenrotte@hotmail.com";
  };
}