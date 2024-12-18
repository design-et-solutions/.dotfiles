{ ... }:
{
  boot.loader = {
    timeout = 3;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      extraConfig = ''
        set superusers="root"
        password_pbkdf2 root grub.pbkdf2.sha512.10000.7D00B32876EABD50E817450F8660DFF994F31CB48B27621CE7259BB22357EDFA29B55095839E5C594FDDC993B05E78CA018BCBEAEBD86E235682019AE3C26E04.E15DFD2B9B95BEDAB5276F1532D6EE518ACA0C063B624FB9BAAB999D114DC77BFF3C54CE09DB2C0040304208DF0B83D7902F1FAAF6BCA12ABD9921936E494773
      '';
    };
    efi.canTouchEfiVariables = true;
  };
}
