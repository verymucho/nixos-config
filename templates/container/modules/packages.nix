{ pkgs, ... }:
let
  myFonts = import ./fonts.nix { inherit pkgs; };
in
with pkgs; [
  # 0-9

  # A
  # act # Run Github actions locally
  # age # File encryption tool
  # age-plugin-yubikey # YubiKey plugin for age encryption

  # B
  bash-completion # Bash completion scripts
  # bat # Cat clone with syntax highlighting
  # bat-extras.core
  # btop # System monitor and process viewer

  # C
  # coreutils # Basic file/text/shell utilities

  # D
  # delta
  # direnv # Environment variable management per directory
  # difftastic # Structural diff tool
  # dockutil # Manage icons on the dock
  dos2unix
  # dust # Disk usage analyzer

  # E
  eza

  # F
  fd # Fast find alternative
  # ffmpeg # Multimedia framework
  # fswatch # File change monitor
  fzf # Fuzzy finder

  # G
  # gcc # GNU Compiler Collection
  # ghostty # GPU-accelerated terminal emulator
  gh # GitHub CLI
  git
  git-lfs
  github-runner
  # glow # Markdown renderer for terminal
  # gnupg # GNU Privacy Guard

  # H
  # htop # Interactive process viewer

  # I
  # iftop # Network bandwidth monitor
  # iperf

  # J
  # jpegoptim # JPEG optimizer
  # jq # JSON processor

  # K
  # killall # Kill processes by name

  # L
  # lftp
  # lnav # Log file navigator
  # libfido2 # FIDO2 library
  # lla
  lsd

  # M
  mkalias
  moor

  # N
  # nano
  # nanorc
  # ncurses # Terminal control library with terminfo database
  # ngrok # Secure tunneling service
  # nodejs_24 # Node.js JavaScript runtime (includes npm)

  # O
  # ookla-speedtest
  # openssh # SSH client and server

  # P
  # pngquant # PNG compression tool

  # Q
  # qt5.qtbase # Qt5 base library with platform plugins

  # R
  # ripgrep # Fast text search tool
  # rsync

  # S
  # socat
  # speedtest-go
  # sqlite # SQL database engine

  # T
  tmux # Terminal multiplexer
  tree # Directory tree viewer

  # U
  # unrar # RAR archive extractor
  unzip # ZIP archive extractor

  # W
  wget # File downloader

  # Z
  zip # ZIP archive creator
  # zsh-powerlevel10k # Zsh theme
] ++ myFonts
