# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  systemd.tmpfiles.rules = [
    "d /media 0755 root root -"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.mullvad-vpn.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable Flatpak
  # services.flatpak.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "nixos";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [
    #   thunderbird
    # ];
  };

  users.users.cameron = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "cameron";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "nixos";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Install Fish
  programs.fish.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for steam local network transfers
  };


  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "spotify"
      "discord"
      "steam"
      "steam-run"
      "steam-original"
      "valheim-server"
      "steamworks-sdk-redist"
    ];
  # ...
  services.valheim = {
    enable = true;
    serverName = "Some cozy server";
    worldName = "Midgard";
    openFirewall = true;
    password = "asdfasdf";
    # If you want to use BepInEx mods.
    # bepinexMods = [
    #   # This does NOT fetch mod dependencies.  You need to add those manually,
    #   # if there are any (besides BepInEx).
    #   (pkgs.fetchValheimThunderstoreMod {
    #     owner = "Somebody";
    #     name = "SomeMod";
    #     version = "x.y.z";
    #     hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    #   })
    #   # ...
    # ];
    # bepinexConfigs = [
    #   ./some_mod.cfg
    #   # ...
    # ];
  };

  # services.firefly-iii = {
  #   enable = true;
  #   settings = {
  #     APP_ENV = "local";
  #     APP_KEY_FILE = home/nixos/firefly-iii-app-key.txt;
  #     SITE_OWNER = "cameroncarlg@gmail.com";
  #     DB_CONNECTION = "mysql";
  #     DB_HOST = "db";
  #     DB_PORT = 3306;
  #     DB_DATABASE = "firefly";
  #     DB_USERNAME = "firefly";
  #   };
  # };

  virtualisation.docker.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    yarn
    remmina
    privoxy
    mullvad
    mullvad-vpn
    # firefly-iii
    vikunja
    kavita
    audiobookshelf
    freshrss
    jellyseerr
    mealie
    docker
    prowlarr
    radarr
    vlc
    qbittorrent
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    gnome-tweaks
    git
    vim 
    neovim
    brave
    lm_sensors
    discord
    spotify
    nodejs_22
    typescript-language-server
    prettierd
    cargo
    
    
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 2456 9000 ];
  networking.firewall.allowedUDPPorts = [ 2456 9000 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}


  # Enable Privoxy
  # services.privoxy = {
  #   enable = true;
  #   enableTor = true;
  # };

  # # Enable Freshrss
  # services.freshrss = {
  #   enable = true;
  #   baseUrl = "http://freshrss";
  #   defaultUser = "admin";
  #   passwordFile = "/home/nixos/temp";
  # };

  # # Enable Sonarr
  # services.sonarr = {
  #   enable = true;
  #   openFirewall = true; 
  # };

  # # Enable Radarr
  # services.radarr = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # services.jellyfin.enable = true;
  # services.prowlarr.enable = true;
  # services.mealie.enable = true;
  # services.jellyseerr.enable = true;
  # services.audiobookshelf.enable = true;
