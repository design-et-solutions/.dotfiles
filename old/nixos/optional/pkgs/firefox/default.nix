{ pkgs, ... }: {
  environment.sessionVariables = {
    BROWSER = "firefox";
  };

  programs.firefox = {
    enable = true;
    languagePacks = [ "fr" "en-US" ];
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
      # ExtensionSettings = {
      #   "*".installation_mode = "blocked"; # blocks all addons except below
      #   "vimium-ff@vimium.com" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
      #     installation_mode = "force_installed";
      #   };
      # };
      Preferences = { 
        "browser.startup.homepage" = "https://nixos.org";
        # "browser.search.region" = "FR";
        # "browser.search.isUS" = false;
        # "browser.bookmarks.managed.enabled" = true;
        # "extensions.screenshots.disabled" = true;
        extensions = [
          (pkgs.fetchFirefoxAddon {
            name = "vimium";
            url = "https://addons.mozilla.org/firefox/downloads/file/4259790/vimium_ff-2.1.2.xpi";
            sha256 = "sha256-O51D7id/83TjsRU/l9wgywbmVBFqgzZ0x5tDuIh4IOE=";
          })
        ];
        # "font.name.monospace.x-western" = "FiraCode Nerd";
        # "font.name.sans-serif.x-western" = "FiraCode Nerd";
        # "font.name.serif.x-western" = "FiraCode Nerd";
        # "browser.bookmarks.managed.enabled" = { Value = true; Status = "locked"; };
        # "browser.contentblocking.category" = { Value = "strict"; Status = "locked"; };
        # "browser.topsites.contile.enabled" = { Value = false; Status = "locked"; };
        # "browser.formfill.enable" = { Value = false; Status = "locked"; };
        # "browser.search.suggest.enabled" = { Value = false; Status = "locked"; };
        # "browser.search.suggest.enabled.private" = { Value = false; Status = "locked"; };
        # "browser.urlbar.suggest.searches" = { Value = false; Status = "locked"; };
        # "browser.urlbar.showSearchSuggestionsFirst" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.feeds.section.topstories" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.feeds.snippets" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.section.highlights.includePocket" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.section.highlights.includeVisited" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.showSponsored" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.system.showSponsored" = { Value = false; Status = "locked"; };
        # "browser.newtabpage.activity-stream.showSponsoredTopSites" = { Value = false; Status = "locked"; };
        # "extensions.pocket.enabled" = { Value = false; Status = "locked"; };
        # "extensions.screenshots.disabled" = { Value = true; Status = "locked"; };
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
