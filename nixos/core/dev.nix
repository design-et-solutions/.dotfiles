{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    rust-analyzer # Rust language server for IDE support
    rustup # Rust toolchain installer
    mold # A modern linker
    nodejs # JavaScript runtime built
    ripgrep # Fast line-oriented search tool, alternative to grep
    postgresql # Advanced open-source relational database
    trash-cli # Command line interface to the freedesktop.org trashcan.
  ];

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    LD_LIBRARY_PATH = "${pkgs.openssl}/lib:${pkgs.openssl.out}/lib:$LD_LIBRARY_PATH";
  };
}
