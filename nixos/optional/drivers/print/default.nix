{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = [ 
      pkgs.hplip 
      pkgs.gutenprint 
      pkgs.cups.pkgs.canon-cups-ufr2
    ];
  };
}
