{ pkgs, ... }: 
let
  aarch64Pkgs = import <nixpkgs> { system = "aarch64-linux"; };
in
{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
  ];
}
