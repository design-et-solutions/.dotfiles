{ config, lib, pkgs, ... }:
{
  imports = [
    "../../../../home/users/me/pkgs/git"
  ];

  users.users = {
    me = {
      initialPassword = "So!weak#0";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [];
      extraGroups = ["wheel", "networkmanager", "audio"];
    };
  };
}