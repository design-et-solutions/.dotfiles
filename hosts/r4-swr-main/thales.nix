{ ... }:
{
  networking = {
    hosts = {
      "192.100.1.1" = [ "cdp.thales" ];
    };
    static = {
      routes = [
        {
          address = "192.100.1.0";
          prefixLength = 24;
          via = "192.168.100.1";
        }
      ];
    };
  };
}
