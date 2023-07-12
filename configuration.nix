{ config, pkgs, ... }:

{
  # System
  system.stateVersion = "23.05";

  # Boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    hostName = "nixos"; # Define your hostname.
  };

  time.timeZone = "America/Mexico_City";
  # User management
  users.extraUsers.joshieadalid = {
    hashedPassword = "$6$UodnzAaZlHThexmm$kQcvK7x1ZmzrKWdPCPYRQktQii3kWR.v2bff0rqg7yjBGGTHMT2BsOieB3rznO5uFsJyTfjyBbHlOmR3/DtZ11";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      firefox
      tree
      jetbrains-mono
      steam
      neofetch
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

  # Xserver
  services.xserver = {
    enable = true;
    videoDrivers = [ "intel" ];
    desktopManager = {
      xfce.enable = true;
    };
    displayManager = {
      defaultSession = "xfce";
      lightdm.enable = true;
    };
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
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
    vim
    wget
    xfce.xfce4-pulseaudio-plugin
    pavucontrol
    networkmanagerapplet
  ];

  # Fonts
  fonts.fonts = with pkgs; [jetbrains-mono];
  
  # Misc
  imports = [./hardware-configuration.nix];
  nixpkgs.config.multilib.enable = true;
  hardware.opengl.driSupport32Bit = true;
}
