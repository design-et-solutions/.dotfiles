{ pkgs, ... }:
{
  imports = [
    ./default.nix
  ];

  environment.systemPackages = with pkgs; [
    iptables
  ];

  networking= {
    nat = {
      enable = true;
      externalInterface = "wlan0";
      internalInterfaces = [ "wg0" ];
    };
    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = [ "10.100.0.1/24" ];
          listenPort = 51820;
          # sudo mkdir -p /etc/wireguard
          # sudo bash -c "wg genkey > /etc/wireguard/private.key" 
          # sudo chmod 600 /etc/wireguard/private.key 
          privateKeyFile = "/etc/wireguard/wg0";
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';
          peers = [
            {
              # desktop-hood
              publicKey = "KhpnhE1PrhNAVfDx+a7PoasfcgvmotdOMmUfMlWAZ1g=";
              allowedIPs = [ "10.100.0.2/32" ];
              persistentKeepalive = 25;
            }
            {
              # laptop-hood
              publicKey = "nbFQwLqGY9riKyd044lTBCQyLPv1xA6g9Hh07g8Fq28=";
              allowedIPs = [ "10.100.0.5/32" ];
              persistentKeepalive = 25;
            }
            {
              # project-handler
              publicKey = "WdtpFPPAHlwHBYrLuYB0pQQNfeqFgsqgyUZTftL910c=";
              allowedIPs = [ "10.100.0.4/32" ];
              persistentKeepalive = 25;
            }
          ];
        };
        };
    };
  };
}
