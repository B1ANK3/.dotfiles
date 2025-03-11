{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "wisp";
  home.homeDirectory = "/home/wisp";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    # Own
    keepassxc
    krita
    # obsidian # ignore 4 now
    kitty-themes
    ranger
    rsync

    # Devtools
    gcc
    gnumake
    # llvm # TODO: Find llvm tools
    rustup
    pnpm # Node package manager
    nodejs_23 # Use shell.nix for projects
    # python # TODO: Careful with python

    # Neovim clipboard
    xsel

    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    fd # sharkdp/fd
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  programs.git = {
    enable = true;

    userName = "B1ANK3";
    userEmail = "44206247+B1ANK3@users.noreply.github.com";

    aliases = {
      tree = ''        log --graph --decorate --pretty=oneline --abbrev-commit --all
        	count-lines = "! git log --author=\"$1\" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\\n\", add, subs, loc }' #"
        	count = "! echo git ls-files | while read f; do git blame -w --line-porcelain -- \"\" | grep -I '^author '; done | sort -f | uniq -ic | sort -n"'';
    };

    extraConfig = {
      init.defaultbranch = "main";
      credential.helper = "cache";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "wedisagree";
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      la = "ls -la";
      sudo = "sudo ";
      v = "nvim";
      rebuild = "sudo nixos-rebuild switch";
    };

    history = {
      size = 5000;
      ignoreAllDups = true;
      path = "$HOME/.zsh_history";
    };
  };

  # TODO: Link config
  programs.neovim = {
    enable = true;
  };

  # Librewolf is cool but lacks sync and breaks on some sites
  programs.librewolf = {
    enable = false;

    settings = {};
  };

  # Try find alt to FF because of the T&C's changed
  programs.firefox = {
    enable = true;

    profiles.wisp = {
      settings = {};

      # Search engines
      search.engines = {
        "Unduck" = {
          urls = [
            {
              template = "https://unduck.link";
              params = [
                {
                  name = "q";
                  value = "%s";
                }
              ];
            }
          ];
          definedAliases = ["@ud"];
        };
      };
      search.force = true;

      # Extensions
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        darkreader
        sponsorblock
        tabliss
        # onetab # Unfree is broken on hm
        return-youtube-dislikes
        keepassxc-browser
        user-agent-string-switcher
      ];
    };
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
      };

      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };
    };
  };

  programs.rofi = {
    enable = true;
  };

  # https://mynixos.com/home-manager/options/programs.kitty
  programs.kitty = {
    enable = true;
    # https://github.com/kovidgoyal/kitty-themes/tree/master/themes
    themeFile = "GruvboxMaterialDarkMedium";

    # For Zsh
    shellIntegration.enableZshIntegration = true;

    font = {
      name = "Fira Code";
      # font_family      family="Fira Code"
      # bold_font        auto
      # italic_font      auto
      # bold_italic_font auto
      size = 11;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
