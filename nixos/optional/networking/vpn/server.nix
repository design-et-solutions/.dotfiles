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
          privateKeyFile = "/etc/wireguard/private.key";
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';
        };
      };
    };
  };
}
