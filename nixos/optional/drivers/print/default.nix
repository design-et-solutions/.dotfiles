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

  systemd.services.set-cupsd-conf-permissions = {
    description = "Set permissions for cupsd.conf";
    after = [ "cups.service" ];
    wantedBy = [ "cups.service" ];
    serviceConfig.ExecStart = ''
      chmod 600 /etc/cups/cupsd.conf
    '';
  };

  services.colord.enable = true;
}
