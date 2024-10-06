{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";


  networking= {
    hostName = "desktop-hood";
  };

  programs.git = {
    config = {
      user.userName  = "Yves Cousteau";
      user.userEmail = "comandant.cousteau1997@gmail.com";
    };
  };
}

