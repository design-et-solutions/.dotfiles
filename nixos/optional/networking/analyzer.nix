{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    tshark # Command-line network protocol analyzer
    suricata # Network threat detection engine
  ];
}
