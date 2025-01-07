{ pkgs, ... }: {
  # https://search.nixos.org/options?channel=24.11&query=networking
  networking= {
    networkmanager = {
      enable = true;
    };
    # https://search.nixos.org/options?query=networking.firewall
    firewall = {
      enable = true;
      logRefusedConnections = true;
      allowedTCPPorts = [ 80 443 8080 ];
      allowedUDPPorts = [ 53 ];
    };
  };  

  # Managing network connections on Linux systems.
  systemd.services.NetworkManager.serviceConfig = {
    NoNewPrivileges = true;

    # ProtectSystem = "full";
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectProc = "invisible";

    PrivateTmp = true;

    RestrictRealtime = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"      # Socket family used for inter-process communication (IPC) 
      "AF_NETLINK"   # Socket family used for communication between user-space applications and the Linux kernel
      "AF_INET"      # IPv4 internet protocol for regular network communication
      "AF_INET6"     # IPv6 internet protocol for regular network communication
      "AF_PACKET"    # Raw packet socket for direct packet-level operations
    ];
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;

    MemoryDenyWriteExecute = true;

    SystemCallFilter = [
      "~@mount"         # Deny mounting operations
      "~@module"        # Deny kernel module options
      "~@swap"          # Deny swap operations
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
      "ptrace"          # ALlow process tracing operations
    ];
    SystemCallArchitectures = "native";

    LockPersonality= true; 
  };

  # Runs custom scripts or actions when specific network-related events occur.
  systemd.services.NetworkManager-dispatcher.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateMounts = true;

    RestrictRealtime = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"      # Socket family used for inter-process communication (IPC) 
      "AF_NETLINK"   # Socket family used for communication between user-space applications and the Linux kernel
      "AF_INET"      # IPv4 internet protocol for regular network communication
      "AF_INET6"     # IPv6 internet protocol for regular network communication
      "AF_PACKET"    # Raw packet socket for direct packet-level operations
    ];
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;

    MemoryDenyWriteExecute = true;

    SystemCallFilter = [
      "~@mount"         # Deny mounting operations
      "~@module"        # Deny kernel module options
      "~@swap"          # Deny swap operations
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
      "ptrace"          # ALlow process tracing operations
    ];
    SystemCallArchitectures = "native";

    LockPersonality= true; 

    CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
  };

  # Managing wireless network connections
  systemd.services.wpa_supplicant.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateMounts = true;

    RestrictRealtime = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"      # Socket family used for inter-process communication (IPC) 
      "AF_NETLINK"   # Socket family used for communication between user-space applications and the Linux kernel
      "AF_INET"      # IPv4 internet protocol for regular network communication
      "AF_INET6"     # IPv6 internet protocol for regular network communication
      "AF_PACKET"    # Raw packet socket for direct packet-level operations
    ];
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;

    MemoryDenyWriteExecute = true;

    SystemCallFilter = [
      "~@mount"         # Deny mounting operations
      "~@raw-io"        # Deny raw I/O operations
      "~@privileged"    # Deny privileged operations
      "~@keyring"       # Deny kernel keyring operations
      "~@reboot"        # Deny rebooting operations
      "~@module"        # Deny kernel module options
      "~@swap"          # Deny swap operations
      "~@resources"     # Deny resource management 
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
      "ptrace"          # ALlow process tracing operations
    ];
    SystemCallArchitectures = "native";

    LockPersonality= true; 

    CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
  };

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanager   
    protobuf       
    nmap
    wget
    websocat
    curl
  ];
}
