{ config, pkgs, ... }:

let
  # Paquetes de Python
  my-python-packages = ps: with ps; [
    tkinter
    datetime
    networkx
  ];
in
{
  # Versión del sistema
  system.stateVersion = "23.05";

  # Configuración del sistema y hardware
  imports = [ ./hardware-configuration.nix ];
  hardware.opengl.driSupport32Bit = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.multilib.enable = true;

  # Networking
  networking = {
    hostName = "desk-joshieadalid";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # Swap
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];

  # Boot
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Zona horaria
  time.timeZone = "America/Mexico_City";

  # Usuarios
  users.extraUsers.joshieadalid = {
    hashedPassword = "$6$UodnzAaZlHThexmm$kQcvK7x1ZmzrKWdPCPYRQktQii3kWR.v2bff0rqg7yjBGGTHMT2BsOieB3rznO5uFsJyTfjyBbHlOmR3/DtZ11"; # Aquí he omitido la contraseña por seguridad
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      python311Packages.tabulate
      firefox
      tree
      neofetch
      jetbrains.pycharm-professional
      google-chrome
      android-tools
    ];
  };

  # Internacionalización
  i18n = {
    defaultLocale = "es_MX.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "es_MX.UTF-8/UTF-8" ];
  };

  # Console
  console.keyMap = "es";

  # Servicio de Xserver
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };
    videoDrivers = [ "intel" ];
  };

  # Otros programas y servicios
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.java.enable = true;
  services.flatpak.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Overlays
  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({ extraPkgs ? pkgs': [], ... }: {
        extraPkgs = pkgs': (extraPkgs pkgs') ++ (with pkgs'; [
          libgdiplus
        ]);
      });
    })
  ];

  # Paquetes del sistema
  environment.systemPackages = with pkgs; [
    flatpak-builder
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
      ];
    })
    (steam.override {
      extraPkgs = pkgs: [ bumblebee glxinfo ];
    }).run
    (python3.withPackages my-python-packages)
    tk
    dotnet-runtime
    vim
    wget
    pavucontrol
    pulseaudio
    udiskie
    networkmanagerapplet
    dmenu
    alacritty
    i3
    i3status
  ];

  # Fuentes
  fonts.fonts = with pkgs; [ jetbrains-mono ];
}
