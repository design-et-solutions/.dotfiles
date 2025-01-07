{ pkgs, ... }:
{
  # manage print http://localhost:631/

  # print ip ipp://192.168.100.232/ipp/print

  # Nmap scan report for 192.168.100.232
  # Host is up (0.019s latency).
  # Not shown: 995 closed tcp ports (conn-refused)
  # PORT     STATE SERVICE
  # 80/tcp   open  http
  # 443/tcp  open  https
  # 515/tcp  open  printer
  # 631/tcp  open  ipp
  # 9100/tcp open  jetdirect

  services.printing = {
    enable = true;
    drivers = with pkgs; [ 
      hplip 
      gutenprint 
    ];
  };

  # Managing printers and print jobs on Linux and other UNIX-like operating systems.
  systemd.services.cups.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "full";
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectHostname = true;
    ProtectProc = "invisible";

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
      "~@resources"
      "~@reboot"
      "~@debug"
      "~@module"        # Deny kernel module options
      "~@swap"          # Deny swap operations
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
    ];
    SystemCallArchitectures = "native";

    LockPersonality= true; 

    CapabilityBoundingSet= [
      "~CAP_MAC_*"
      "~CAP_CHOWN"
      "~CAP_FSETID"
      "~CAP_SETFCAP"
    ];
  };

  services.colord.enable = true;
}
