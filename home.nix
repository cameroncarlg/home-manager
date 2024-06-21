{ config, pkgs, ... }:

{
  # Home Manager needs to know where to manage
  home.username = "cameron";
  home.homeDirectory = "/Users/cameron";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Install Nix packages into your $USER env
  home.packages = with pkgs; [
    neovim # Modern Unix 'vi'
    htop # Modern Unix 'top'
    btop # Even ~more~ Modern Unix 'top'
    bmon # Modern Unix 'iftop'
    chafa # Terminal image viewer
    tldr # Modern Unix 'man'
    tokei # Modern Unix 'wc' for code
    wthrr # Terminal Weather App
    gping # Modern Unix 'ping'
    hr # Terminal horizontal rule
    fd # Modern Unix 'find'
    hyperfine # Terminal benchmarking
    iperf3 # Terminal network benchmarking
    mtr # Modern Unix 'traceroute'
    wget # Terminal HTTP client
    wget2 # Terminal HTTP client
    procs # Modern Unix 'ps'
    fastfetch # Modern PC info
    neo-cowsay # Terminal ASCII cow
    speedtest-go # Terminal speedtest
    terminal-parrot # Terminal ASCII parrot
    nyancat # Modern Unix nyancat
    dotacat # Modern Unix lolcat
    cpufetch # Terminal CPU info
    lazygit # Terminal git interface
    bat # Modern Unix 'cat'
    nix-prefetch-git # TBD
    nix-prefetch-github # TBD
    nix-prefetch
    nh # Yet another Nix helper
    m-cli # TBD
    # broot # Terminal File System navigator
    gh # GitHub CLI
    tig # Text mode interface for git
    nodejs_22 # Nodejs
    python3 # Python3
    vscodium # Opensource Non-Telemetrey VSCode
    nerdfonts # NerdFonts
    fira-code # FiraCode
    lazydocker
    openvpn
    nmap


    # Unsupported on MacOS

    # vlc # VLC Media Player
    # asciicam # Terminal webcam
    # asciinema-agg # Convert asciinema to .gif
    # asciinema # Terminal recorder
    # bandwhich # Modern Unix 'iftop'
      
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')

    (pkgs.writeShellScriptBin "fetchsha" ''
      nix-prefetch-github-latest-release --meta -v $1 $2
    '')
  ];

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
    settings.modal = true;
    settings.verbs = [
      { invocation = "edit"; execution = "$EDITOR {file}"; }
      { invocation = "create {subpath}"; execution = "$EDITOR {directory}/{subpath}"; }
      { invocation = "view"; execution = "toggle_preview {file}"; }
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--colors=line:style:bold"
      "--max-columns-preview"
      "--smart-case"
    ];
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        lightTheme = true;
        activeBorderColor = [ "blue" "bold" ];
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "cameroncarlg";
    userEmail = "cameroncarlg@gmail.com";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      # the language-server option currently requires helix from the master branch at https://github.com/helix-editor/helix/
      language-server.typescript-language-server = with pkgs.nodePackages; {
        command = "${typescript-language-server}/bin/typescript-language-server";
        args = [ "--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib" ];
      };
      language-server.html-ls = with pkgs.nodePackages; {
        command = "${vscode-html-languageserver-bin}/bin/vscode-html-languageserver";
        args = [ "--stdio" ];
        env = {
          PATH = "${pkgs.nodePackages.vscode-html-languageserver-bin}/bin:${pkgs.nodePackages.nodejs}/bin:${pkgs.coreutils}/bin:$PATH";
        };
      };
      language-server.json-ls = with pkgs.nodePackages; {
        command = "${vscode-json-languageserver-bin}/bin/vscode-json-languageserver-bin";
        args = [ "--stdio" ];
        env = {
          PATH = "${pkgs.nodePackages.vscode-json-languageserver-bin}/bin:${pkgs.nodePackages.nodejs}/bin:${pkgs.coreutils}/bin:$PATH";
        };
      };
      language = [
        {
          name = "rust";
          auto-format = false;
        }
        {
          name = "html";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "{}" "--parser" "html" ];
          };
        }
        {
          name = "css";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "{}" "--parser" "css" ];
          };
        }
        {
          name = "javascript";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "{}" ];
          };
        }
        {
          name = "typescript";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "{}" ];
          };
        }
        {
          name = "jsx";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "{}" "--parser" "jsx" ];
          };
        }
        {
          name = "tsx";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "{}" "--parser" "tsx" ];
          };
        }
        {
          name = "json";
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = [ "--stdin-filepath" "{}" "--parser" "json" ];
          };
        }
      ];
    };
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
      keys.normal.";" = {
        b = ":sh helix-wezterm.sh blame";
        c = ":sh helix-wezterm.sh check";
        e = ":sh helix-wezterm.sh explorer";
        f = ":sh helix-wezterm.sh fzf";
        g = ":sh helix-wezterm.sh lazygit";
        o = ":sh helix-wezterm.sh open";
        r = ":sh helix-wezterm.sh run";
        s = ":sh helix-wezterm.sh test_single";
        t = ":sh helix-wezterm.sh test_all";
      };
    };
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      sw = "home-manager switch";
      wthr = "wthrr -u f,12h,in";
      nf = "fastfetch";
      ll = "br -sdp";
    };
    functions = {
      trash = "mv $argv[1] $HOME/.Trash";
      hxc = "sudo hx /Users/cameron/.config/home-manager/home.nix";
      code = "codium";
    };
    interactiveShellInit = "
      set fish_greeting
    ";
    plugins = [
      {
        name = "fzf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          hash  = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
      {
        name = "autopair.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "244bb1ebf74bf944a1ba1338fc1026075003c5e3";
          hash = "sha256-s1o188TlwpUQEN3X5MxUlD/2CFCpEkWu83U9O+wg3VU=";
        };
      }
      {
        name = "done";
        src = pkgs.fetchFromGitHub {
          owner = "franciscolourenco";
          repo = "done";
          rev = "eb32ade85c0f2c68cbfcff3036756bbf27a4f366";
          hash = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
        };
      }
    ];
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = wezterm.config_builder()

      config.color_scheme = 'Catppuccin Mocha'
      config.use_fancy_tab_bar = false
      config.show_new_tab_button_in_tab_bar = false
      config.window_background_opacity = 0.925
      config.macos_window_background_blur = 30
      config.mouse_wheel_scrolls_tabs = true
      config.font = wezterm.font("Fira Code")
      config.enable_scroll_bar = true

      config.keys = {
        { key = 'Enter', mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal {domain = 'CurrentPaneDomain' }},
        { key = 'Enter', mods = 'CMD', action = wezterm.action.SplitVertical {domain = 'CurrentPaneDomain' }},
        { key = 't', mods = 'CMD|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
        { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane {confirm = true }},
        { key = 'w', mods = 'CMD|SHIFT', action = wezterm.action.CloseCurrentTab {confirm = true }},
        { key = 'j', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Next' },
        { key = 'k', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Prev' },
        { key = 'h', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Right' },
        { key = 'h', mods = 'CMD|SHIFT', action = wezterm.action.AdjustPaneSize { 'Left', 5 }},
        { key = 'j', mods = 'CMD|SHIFT', action = wezterm.action.AdjustPaneSize { 'Down', 5 }},
        { key = 'k', mods = 'CMD|SHIFT', action = wezterm.action.AdjustPaneSize { 'Up', 5 }},
        { key = 'l', mods = 'CMD|SHIFT', action = wezterm.action.AdjustPaneSize { 'Right', 5 }},
        { key = 'n', mods = 'CMD', action = wezterm.action.TogglePaneZoomState },
        { key = 'p', mods = 'CMD', action = wezterm.action.ToggleFullScreen },
      }
      return config
    '';

  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/cameron/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
