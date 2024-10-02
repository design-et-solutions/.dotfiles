{ pkgs, ... }: 
{
  environment.systemPackages = with pkgs; [
    buildInputs = [ pkgs.nodePackages.mermaid-cli ];
  ];
}
