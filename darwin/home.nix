{ config, pkgs, user, ... }:

{
  home = {
    username = "${user}";
    homeDirectory = "/Users/${user}";
    stateVersion = "22.05";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "alacritty";
    };
    packages = with pkgs; [
      # shell prompt
      starship
      # cli utilities
      ranger
      fd
      ripgrep
      bat
      lsd
      jq
      wget
      tree
      btop
      spotify-tui
    ];
  };

  programs = {
    home-manager = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "${fullName}";
      userEmail = "${gitEmail}";
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      enableCompletion = true;
      defaultKeymap = "viins";
      history.size = 10000;
      initExtra = ''
        eval "$(starship init zsh)"
      '';
      shellAliases = {
        ls = "lsd -lah";
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    lsd = {
      enable = true;
      settings = {
        classic = false;
	blocks = [
          "permission"
	  "user"
	  "size"
	  "date"
	  "name"
	];
	date = "+%d %b %R";
	icons = {
          when = "auto";
	  theme = "fancy";
	  separator = " ";
	};
	layout = "grid";
	sorting = {
          column = "name";
	  reverse = false;
	  dir-grouping = "first";
	};
        symlink-arrow = "->";
      };
    };
    alacritty = {
      enable = true;
      # fake package - managed by homebrew instead
      package = pkgs.runCommand "firefox-0.0.0" {} "mkdir $out";
      settings = {
        live_config_reload = true;
        dynamic_title = true;
        window.padding = {
          x = 15;
          y = 28;
        };
        font = {
          size = 13.0; 
          # offset.y = 2;
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
        };
        draw_bold_text_with_bright_colors = true;
        colors = {
          cursor.cursor = "#f7f1ff";
          primary.background = "#363537";
          primary.foreground = "#f7f1ff";
          normal = {
            black = "#363537";
            red = "#fc618d";
            green = "#7db88f";
            yellow = "#fce566";
            blue = "#fd9353";
            magenta = "#948ae3";
            cyan = "#5ad4e6";
            white = "#f7f1ff";
          };
          bright = {
            black = "#69676c";
            red = "#fc618d";
            green = "#7db88f";
            yellow = "#fce566";
            blue = "#fd9353";
            magenta = "#948ae3";
            cyan = "#5ad4e6";
            white = "#f7f1ff";
          };
	};
      };
    };
    firefox = {
      enable = true;
      # fake package - managed by homebrew instead
      package = pkgs.runCommand "firefox-0.0.0" {} "mkdir $out";
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        vimium
        decentraleyes
        # 1password
        privacy-badger
        darkreader
      ];
      profiles."${user}" = {
        isDefault = true;
        settings = {
          "app.normandy.api_url" = "";
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "app.update.auto" = false;
          "beacon.enabled" = false;
          "breakpad.reportURL" = "";
          "browser.aboutConfig.showWarning" = false;
          "browser.cache.offline.enable" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.disableResetPrompt" = true;
          "browser.newtab.preload" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.enhanced" = false;
          "browser.newtabpage.introShown" = true;
          "browser.safebrowsing.appRepURL" = "";
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.enabled" = false;
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.search.suggest.enabled" = false;
          "browser.selfsupport.url" = "";
          "browser.send_pings" = false;
          "browser.sessionstore.privacy_level" = 2;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.urlbar.groupLabels.enabled" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.urlbar.trimURLs" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "device.sensors.ambientLight.enabled" = false;
          "device.sensors.enabled" = false;
          "device.sensors.motion.enabled" = false;
          "device.sensors.orientation.enabled" = false;
          "device.sensors.proximity.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.event.clipboardevents.enabled" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "dom.webaudio.enabled" = false;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          "experiments.supported" = false;
          "extensions.getAddons.cache.enabled" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.pocket.enabled" = false;
          "media.autoplay.default" = 1;
          "media.autoplay.enabled" = false;
          "media.navigator.enabled" = false;
          "media.peerconnection.enabled" = false;
          "media.video_stats.enabled" = false;
          "network.allow-experiments" = false;
          "network.captive-portal-service.enabled" = false;
          "network.cookie.cookieBehavior" = 1;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.http.referer.spoofSource" = true;
          "network.http.speculative-parallel-limit" = 0;
          "network.predictor.enable-prefetch" = false;
          "network.predictor.enabled" = false;
          "network.prefetch-next" = false;
          "privacy.query_stripping" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          "privacy.usercontext.about_newtab_segregation.enabled" = true;
          "security.ssl.disable_session_identifiers" = true;
          "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
          "signon.autofillForms" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "webgl.disabled" = true;
          "webgl.renderer-string-override" = " ";
          "webgl.vendor-string-override" = " ";
        };
      };
    };
    zathura = {
      enable = true;
      package = pkgs.zathura;
      extraConfig = ''
	set recolor
	set guioptions ""
	set recolor-lightcolor \#1f2227
	set default-bg \#1f2227
	set adjust-open "best-fit"
	set scroll-page-aware "true"
	set sandbox none
	set statusbar-h-padding 0
	set statusbar-v-padding 0
	map K zoom in
	map R rotate
	map r reload
	map J zoom out
	set selection-clipboard clipboard
	set notification-error-bg       "#222222" # bg0
	set notification-error-fg       "#fc618d" # red
	set notification-warning-bg     "#222222" # bg0
	set notification-warning-fg     "#fce566" # yellow
	set notification-bg             "#222222" # bg0
	set notification-fg             "#7bd88f" # green
	set completion-bg               "#2d2c2d" # bg2
	set completion-fg               "#f7f1ff" # fg0
	set completion-group-bg         "#403e41" # bg1
	set completion-group-fg         "#69676c" # gray
	set completion-highlight-bg     "#5ad4e6" # blue
	set completion-highlight-fg     "#2d2c2d" # bg2
	# Define the color in index mode
	set index-bg                    "#2d2c2d" # bg2
	set index-fg                    "#f7f1ff" # fg0
	set index-active-bg             "#5ad4e6" # blue
	set index-active-fg             "#2d2c2d" # bg2
	set inputbar-bg                 "#2d2c2d" # bg2
	set inputbar-fg                 "#f7f1ff" # fg0
	set statusbar-bg                "#2d2c2d" # bg2
	set statusbar-fg                "#f7f1ff" # fg0
	set highlight-color             "#fce566" # yellow
	set highlight-active-color      "#fd9353" # orange
	set default-bg                  "#222222" # bg0
	set default-fg                  "#f7f1ff" # fg1
	set render-loading              true
	set render-loading-bg           "#222222" # bg0
	set render-loading-fg           "#f7f1ff" # fg0
	# Recolor book content's color
	set recolor-lightcolor          "#222222" # bg0
	set recolor-darkcolor           "#f7f1ff" # fg0
	set recolor                     "true"
	set recolor-keephue             true      # keep original color
      '';
    };
    neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      viAlias = true;
      vimAlias = true;
    };
  };
}
