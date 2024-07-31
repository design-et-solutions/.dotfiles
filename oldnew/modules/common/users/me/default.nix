{ inputs, config, lib, pkgs, ... }:
{
  imports = [
    ../../../modules/home/core 
    "../../../home/users/me/pkgs/git"
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  users.users = {
    me = {
      initialPassword = "Oups";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [];
      extraGroups = ["wheel"];
    };
  };

}