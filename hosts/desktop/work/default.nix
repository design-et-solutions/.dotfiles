{ pkgs, lib, ... }:{
  imports = [
    # Import general core 
    ./../../..
  ];
  
  time.timeZone = "Europe/Paris";
}
