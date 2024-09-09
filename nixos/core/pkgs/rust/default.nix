{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    rustc
    cargo
    rust-analyzer
    rustfmt
  ];

  environment.shellInit = ''
    export PATH=$PATH:$HOME/.cargo/bin
  '';
}
