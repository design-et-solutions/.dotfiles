{ pkgs, ... }:
{
  imports = [
    ./git
    ./dev
    ./misc
    ./monitoring
    ./usb
  ];

  environment.systemPackages = with pkgs; [
    gcc # GNU Compiler Collection (C and C++ compilers)
    glibc # GNU C Library, the standard C library
    nix-index # Indexes the Nix store to allow fast file lookup
    pkg-config # Helper tool used when compiling applications
    clang # C language family frontend for LLVM
  ];
}
