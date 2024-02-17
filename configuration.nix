{ config, pkgs, ... }:

{
  # System
  system.stateVersion = "23.05";

  # Boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Hardware Configuration
  hardware = {
    firmware = [ pkgs.linux-firmware ];
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = [ pkgs.mesa.drivers];
    };
  };

  # Services
  services = {
    teamviewer.enable = true;
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
        server_names = ["cloudflare" "google"];
      };
    };
    gvfs.enable = true; # Mount, trash, and other functionalities
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    flatpak.enable = true;
    dbus.enable = true;
   
    blueman.enable = true;
  };

 xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

  # Networking
  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
    hostName = "latitude"; # Define your hostname.
    nameservers = [ "127.0.0.1" "::1" ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  time.timeZone = "America/Mexico_City";
  # User management
  users.extraUsers.joshieadalid = {
    hashedPassword = "$6$UodnzAaZlHThexmm$kQcvK7x1ZmzrKWdPCPYRQktQii3kWR.v2bff0rqg7yjBGGTHMT2BsOieB3rznO5uFsJyTfjyBbHlOmR3/DtZ11";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Internationalisation
  i18n = {
    defaultLocale = "es_MX.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "es_MX.UTF-8/UTF-8" ];
  };
  
  console = {
    keyMap = "es";
  };

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 

  services.xserver = {
    enable = true;
    layout = "es";
    xkbOptions = "eurosign:e";
    desktopManager.mate.enable = true;
    displayManager.lightdm.enable = true;
    videoDrivers = [ "intel" ];
  };


  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    virt-manager
    xdg-utils
    glib
    mate.mate-system-monitor
  ];

  # Fonts
  fonts.packages = with pkgs; [jetbrains-mono inconsolata];
  
  # Misc
  imports = [./hardware-configuration.nix]; 
  nixpkgs.config.multilib.enable = true;
  
  # Virtualización
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  
  nix.optimise.automatic = true;

  programs.steam = {
    dedicatedServer.openFirewall = true;
  };
  
  security.polkit.enable = true;
  users.users.joshieadalid.extraGroups = [ "video" ];
  programs.light.enable = true;

  
  
  services.postgresql = {
  enable = true;
  authentication = pkgs.lib.mkOverride 10 ''
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    local   all             all                                     peer
    host    all             all             127.0.0.1/32            md5
    host    all             all             ::1/128                 md5
  '';
  };


}
