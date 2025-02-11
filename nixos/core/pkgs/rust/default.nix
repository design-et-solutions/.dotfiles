{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rust-analyzer
    rustup
    pkg-config
    openssl
    mold
    clang
  ];

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    LD_LIBRARY_PATH = "${pkgs.openssl}/lib:${pkgs.openssl.out}/lib:$LD_LIBRARY_PATH";
  };
}
