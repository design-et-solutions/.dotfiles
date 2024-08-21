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
      # BlockAboutConfig = true;
      DefaultDownloadDirectory = "~/Downloads";
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except below
        "vimium-ff@vimium.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4259790/vimium_ff-2.1.2.xpi";
          installation_mode = "force_installed";
        };
      };
      Preferences = { 
        "browser.bookmarks.managed.enabled" = lock-true;
        "browser.contentblocking.category" = { 
          Value = "strict"; 
          Status = "locked"; 
        };
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" = lock-true;
      };
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
              title = "DS Services";
              url = "http://192.168.5.16";
            }
          ];
        }
        {
          title = "Wallpapers";
          children = [
            {
              title = "Gruvbox";
              url = "https://gruvbox-wallpapers.pages.dev";
            }
          ];
        }
      ];
    };
  };
}
