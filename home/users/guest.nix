{ pkgs, ... }: {
  imports = [
    # Import optional
  ];

  home = {
    username = "guest";
    homeDirectory = "/home/guest";
  };

  home.packages = with pkgs; [ 
  ];
}
