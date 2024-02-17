{ config, pkgs, lib, ... }:
with pkgs;
let
  unstable = import <nixpkgs-unstable> {
    config = {
      allowUnfree = true;
    };
  };

  # -- Entorno de python --
  pythonLibs = with pkgs.python3Packages; [
    # Análisis y manipulación de datos
    pandas openpyxl statsmodels

    # Visualización
    matplotlib seaborn imageio pydot pygraphviz

    # Machine learning y procesamiento de imágenes
    scikit-learn scikit-image (opencv4.override { enableGtk2 = true; })

    # Manipulación y análisis de redes
    networkx scipy

    # Procesamiento de texto y HTML
    beautifulsoup4 requests fuzzywuzzy

    # Otras librerías científicas y de matemáticas
    sympy

    # Creación de juegos y visualizaciones interactivas
    pygame

    # Herramientas de desarrollo y notebooks
    jupyter

    # Bases de datos
    sqlalchemy
  ];


  # R-with-my-packages = rWrapper.override{ packages = with rPackages; [ irace ]; };
  RStudio-with-my-packages = rstudioWrapper.override{ packages = with rPackages; [ irace ]; };
  myPythonEnv = pkgs.python3.buildEnv.override {
    extraLibs = pythonLibs;
  };

  # ---- FHS Julia environment ----
  juliaFhsEnv = pkgs.buildFHSEnv {
    name = "julia-fhs-env";
    targetPkgs = pkg: with pkgs; [
      julia
    ];
  };
  myNerdfonts = pkgs.nerdfonts.override {
    fonts = [ "FiraCode" "DroidSansMono" ]; # Añade aquí los nombres de las fuentes que quieras
  };
in
{
  home.username = "joshieadalid";
  home.homeDirectory = "/home/joshieadalid";
  home.stateVersion = "23.05";
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg)
      [ "vscode" "google-chrome" "steam-run" "steam-original" ];
  };

  # ---- Packages ----
  home.packages = with pkgs; [
    # Misc
    jetbrains-mono neofetch tree
    libgdiplus libcxx
    # Internet
    firefox google-chrome
    steam-run
    thunderbird
    telegram-desktop
    unstable.zoom-us
    #teams-for-linux
    thunderbird
    teamviewer
    #Math
    maxima
    git htop alacritty
    graphviz sxiv mpv strawberry gtk3 gtk4 xorg.libX11 gdk-pixbuf.dev glib
    wget dpkg
    # Development
    juliaFhsEnv
    myPythonEnv
    jetbrains.pycharm-professional
    jetbrains.clion
    jetbrains.idea-ultimate
    vim
    rustup
    android-tools
    # Office
    libsForQt5.okular
    unstable.texstudio unstable.texlive.combined.scheme-full
    # Libreoffice
    libreoffice-fresh hunspell hunspellDicts.es_MX
    # Support
    anydesk
    woeusb
    ntfs3g
    # Desktop experience
    redshift
    josm
    xclip
    maim
    gparted
    woeusb
    
    alsa-utils
    pulseaudio
    
    lm_sensors
    myNerdfonts
    unzip
    bluez
    # C
    gcc cmake glibc
    garamond-libre

    keepassxc
    qgis
    dolphin-emu
    xorg.libxcb
    speedtest-cli
    discord

    peazip
    qt5.full
    qtcreator

    postgresql
    kotlin
  ];

  # ---- Programs ----
  programs.home-manager.enable = true;
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      james-yu.latex-workshop
    ];
  };
}
