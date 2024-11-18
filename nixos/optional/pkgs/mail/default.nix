{ pkgs, lib, ... }:{
  environment.systemPackages = with pkgs; [
    neomutt
  ];

  environment.etc."neomuttrc".source = .source = ./config;
}
