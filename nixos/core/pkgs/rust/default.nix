{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
    rustup
    pkg-config
    openssl   
  ];

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    LD_LIBRARY_PATH = "${pkgs.openssl}/lib:${pkgs.openssl.dev}/lib:$LD_LIBRARY_PATH";
  };
}

