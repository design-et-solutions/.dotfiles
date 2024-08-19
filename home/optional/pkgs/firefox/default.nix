{ ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "fr" "en-US" ];
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
    };
    policies = {
      BlockAboutConfig = true;
      DefaultDownloadDirectory = "~/Downloads";
      ManagedBookmarks = [
        {
          title = "Perplexity";
          url = "https://www.perplexity.ai/";
        }
        {
          title = "Reddit";
          url = "https://www.reddit.com";
        }
        {
          title = "Programing";
          children = [
            {
              title = "Icons";
              children = [
                {
                  title = "Google";
                  url = "https://fonts.google.com/icons";
                }
                {
                  title = "Font Awesome 5";
                  url = "https://fontawesome.com/v5/search";
                }
              ];
            }
            {
              title = "Github";
              url = "https://github.com/";
            }
            {
              title = "Nerd Fonts";
              url = "https://www.nerdfonts.com/";
            }
            {
              title = "Colors";
              url = "https://coolors.co/";
            }
            {
              title = "Nixos";
              url = "https://mynixos.com/";
            }
          ];
        }
        {
          title = "Work";
          children = [
            {
              title = "Local";
              url = "http://192.168.5.16";
            }
          ];
        }
      ];
    };
  };
}
