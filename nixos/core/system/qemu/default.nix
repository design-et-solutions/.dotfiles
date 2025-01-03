{
  virtualisation = {
    qemu = {
      enable = true;
      memorySize = 2048; # Adjust as needed
      cpuCount = 2;      # Adjust as needed
      extraOptions = [
        "-enable-kvm"
        "-cpu host"
      ];
    };
  };
}
