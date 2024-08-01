{ 
  ... 
}:
{
  imports = [
    # Import general core 
    ../../nixos/core 
    ../../nixos/core/shell/fish 
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
  ];

  networking.hostName = "template";
}
