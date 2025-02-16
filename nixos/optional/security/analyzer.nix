{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lynis # Security auditing tool for Unix/Linux systems
    nikto # Web server scanner for security vulnerabilities
  ];
}
