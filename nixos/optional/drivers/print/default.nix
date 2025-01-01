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

  systemd.services.cups.serviceConfig = {
    # nonewprivileges = true;
    #
    # protectsystem = "strict"; # mounts everything read-only with the exception of /dev, /proc and /sys
    # protecthome = true;
    # protectkernelmodules = true; # prevents explicit kernel module loading
    # protectnetwork = true;
    # protectcontrolgroups = true; # protects the linux control groups from modification
    # protectkerneltunables = true; # prevents kernel tunables from being modified
    # protectkernellogs = true; # denies access to the kernel log ring buffer
    # protecthostname = true; # prevents the service from changing the hostname and/or react to changes of the hostname
    # protectclock = true; # denies all write requests to the hardware clock.
    #
    # restrictaddressfamilies = "af_unix af_inet af_inet6 af_netlink"; # restrict the available socket address families
    # restrictnamespaces = true; # access to namespacing functionality is restricted
    # restrictrealtime = true; # prevents the service from enabling realtime scheduling policies, which could be used to fully occupy the system
    # restrictsuidsgid = true; # prevents the setting of the suid or guid on files or directories
    #
    # privatetmp = true; # private directory for temporary files
    # privatedevices = true; # prevents access to physical devices
    # privateusers = true; # prevents the access to the home directories of other users
    #
    # devicepolicy= "closed"; # prevent access to physical devices unless explicitly allowed
    # memorydenywriteexecute = true; # prevents the creation or modification of memory mappings as executable
    # lockpersonality = true; # prevents the change of the personality settings for this process
    # capabilityboundingset = "~cap_linux_immutable cap_ipc_lock cap_sys_chroot cap_block_suspend cap_lease cap_sys_admin cap_sys_boot cap_sys_pacct cap_sys_ptrace cap_sys_rawio cap_sys_time cap_sys_tty_config cap_wake_alarm cap_mac_admin cap_mac_override cap_setuid cap_setgid cap_setpcap cap_chown cap_net_admin cap_fsetid cap_setfcap cap_dac_override cap_dac_read_search cap_fowner cap_ipc_owner"; # disables (via the ‘~’ sign) various potentially dangerous capabilities that this service doesn’t need anyway
  };

  services.colord.enable = true;
}
