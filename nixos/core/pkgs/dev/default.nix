{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rust-analyzer # Rust language server for IDE support
    rustup # Rust toolchain installer
    openssl # OpenSSL library for cryptography
    mold # A modern linker
    nodejs # JavaScript runtime built
  ];

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    LD_LIBRARY_PATH = "${pkgs.openssl}/lib:${pkgs.openssl.out}/lib:$LD_LIBRARY_PATH";
  };
}
