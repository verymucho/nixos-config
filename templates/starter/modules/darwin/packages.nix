{ pkgs, ... }:
let
  # myPython = pkgs.python3.withPackages (ps: with ps; [
  #   slpp
  #   pip
  #   rich
  #   mysql-connector
  #   virtualenv
  #   black
  #   requests
  #   faker
  #   textual
  #   pyqt5
  #   pyyaml
  #   feedparser
  #   python-dateutil
  # ]);

  # myPHP = pkgs.php82.withExtensions ({ enabled, all }: enabled ++ (with all; [
  #   xdebug
  # ]));

  myFonts = import ./fonts.nix { inherit pkgs; };
in
with pkgs; [
  # 0-9

  # A
  # act # Run Github actions locally
  # age # File encryption tool
  # age-plugin-yubikey # YubiKey plugin for age encryption
  # alacritty # GPU-accelerated terminal emulator
  # aspell # Spell checker
  # aspellDicts.en # English dictionary for aspell

  # B
  bash-completion # Bash completion scripts
  bat # Cat clone with syntax highlighting
  # bat-extras.core
  btop # System monitor and process viewer

  # C
  # colima
  # coreutils # Basic file/text/shell utilities

  # D
  # delta
  # devbox
  # direnv # Environment variable management per directory
  # difftastic # Structural diff tool
  dockutil # Manage icons on the dock
  dos2unix
  # dust # Disk usage analyzer

  # E
  eza

  # F
  fd # Fast find alternative
  # ffmpeg # Multimedia framework
  fswatch # File change monitor
  fzf # Fuzzy finder

  # G
  # gcc # GNU Compiler Collection
  # ghostty # GPU-accelerated terminal emulator
  gh # GitHub CLI
  git
  git-lfs
  # glow # Markdown renderer for terminal
  # gnupg # GNU Privacy Guard
  # gopls # Go language server

  # H
  # htop # Interactive process viewer
  # hunspell # Spell checker

  # I
  # iftop # Network bandwidth monitor
  # imagemagick # Image manipulation toolkit
  # iperf
  # iterm2

  # J
  # jetbrains.phpstorm # PHP IDE
  # jpegoptim # JPEG optimizer
  # jq # JSON processor

  # K
  # killall # Kill processes by name

  # L
  lftp
  # lnav # Log file navigator
  # libfido2 # FIDO2 library
  # lla
  lsd

  # M
  mkalias
  # moor
  # mosh
  # myPHP # Custom PHP with extensions
  # myPython # Custom Python with packages

  # N
  # nano
  # nanorc
  # ncurses # Terminal control library with terminfo database
  # neofetch # System information tool
  # ngrok # Secure tunneling service
  # nodejs_24 # Node.js JavaScript runtime (includes npm)

  # O
  # ookla-speedtest
  # openssh # SSH client and server

  # P
  # pandoc # Document converter
  # php82Packages.composer # PHP dependency manager
  # deployer # PHP deployment tool
  # php82Packages.php-cs-fixer # PHP code style fixer
  # php82Packages.phpstan # PHP static analysis tool
  # phpactor # PHP language server with better refactoring support
  # phpunit # PHP testing framework
  # pngquant # PNG compression tool

  # Q
  # qt5.qtbase # Qt5 base library with platform plugins

  # R
  # repomix # AI tooling
  # ripgrep # Fast text search tool
  # rsync

  # S
  # slack # Team communication app
  # socat
  # speedtest-go
  # sqlite # SQL database engine

  # T
  # terraform # Infrastructure as code tool
  # terraform-ls # Terraform language server
  # tflint # Terraform linter
  tmux # Terminal multiplexer
  tree # Directory tree viewer

  # U
  # unrar # RAR archive extractor
  # unzip # ZIP archive extractor
  # utm
  # uv # Python package installer

  # W
  wget # File downloader

  # Z
  # zed-editor
  zip # ZIP archive creator
  # zsh-powerlevel10k # Zsh theme
] ++ myFonts
