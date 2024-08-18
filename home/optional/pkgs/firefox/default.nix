{ ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "fr" "en-US" ];
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
    };
  };
}
