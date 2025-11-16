{ config, pkgs, lib, home-manager, ... }:

let
  name = "%NAME%";
  user = "%USER%";
  email = "%EMAIL%";
  # additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  # imports = [
  #  ./config/dock
  # ];

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    brews = pkgs.callPackage ./brews.nix {};
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
      upgrade = true;
    };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    masApps = {
      # "developer" = 640199958;
      # "imazing profile editor" = 1487860882;
      # "mediainfo" = 510620098;
      "previewtext" = 1660037028;
      # "testflight" = 899247664;
      # "wireguard" = 1451685025;
    };
  };

  # direnv = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   nix-direnv.enable = true;
  # };

  zsh = {
    enable = true;
    autocd = false;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config;
        file = "p10k.zsh";
      }
    ];

    initContent = lib.mkBefore ''
      if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      fi

      [[ $(whence fzf) ]] && source <(fzf --zsh)

      [[ -x /opt/homebrew/opt/curl/bin/curl ]] && alias curl=/opt/homebrew/opt/curl/bin/curl
      [[ -x /opt/homebrew/opt/curl/bin/curl-config ]] && alias curl-config=/opt/homebrew/opt/curl/bin/curl-config
      [[ -x /opt/homebrew/opt/curl/bin/wcurl ]] && alias wcurl=/opt/homebrew/opt/curl/bin/wcurl

      export EDITOR=nano

      # Define variables for directories
      [[ -d $HOME/.local/share/bin ]] && export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:cd"
      HISTCONTROL=ignoreboth
      HISTSIZE=1000000000
      HISTFILESIZE=1000000000

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      [[ $(whence eza) ]] && alias eza="eza -Agh --classify=auto --smart-group --group-directories-first --no-quotes --time-style=long-iso --color=auto --color-scale=all --color-scale-mode=gradient --icons=auto"
      [[ $(whence eza) ]] && alias l="eza -lH"
      [[ $(whence eza) ]] && alias lg="eza -l --git --git-repos"
      [[ $(whence lsd) ]] && alias la="lsd -SAFlr --total-size --group-dirs none"
      [[ $(whence lsd) ]] && alias ll="lsd -SAFl --total-size --group-dirs none"
      [[ $(whence eza) ]] && alias ls="eza -lGH"
      [[ $(whence eza) ]] && alias lt="ls -T"
      [[ $(whence tree) ]] && alias tree="tree -a -I .git --dirsfirst"
      alias sudo='sudo -H '

      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
    '';
  };

  # bat = {
  #   enable = true;
  #   config = {
  #     color = "always";
  #     decorations = "always";
  #     italic-text = "always";
  #     theme = "Dracula";
  #   };
  #   extraPackages = [ pkgs.bat-extras.core ];
  # };

  # eza = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   colors = "auto";
  #   extraOptions = [ "-Agh" "--classify=auto" "--smart-group" "--group-directories-first" "--no-quotes" "--time-style=long-iso" "--color-scale=all" "--color-scale-mode=gradient" "--git-repos" ];
  #   git = true;
  #   icons = "auto";
  # };

  # fzf = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   defaultOptions = [ "--style=full" ];
  # };

  git = {
    enable = true;
    ignores = [ "*.swp" "*.zwc" ".DS_Store" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      # core = {
      #   editor = "vim";
      #   autocrlf = "input";
      # };
      commit.gpgsign = true;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };

  # vim = {
  #   enable = true;
  #   plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes vim-startify vim-tmux-navigator ];
  #   settings = { ignorecase = true; };
  #   extraConfig = ''
  #     "" General
  #     set number
  #     set history=1000
  #     set nocompatible
  #     set modelines=0
  #     set encoding=utf-8
  #     set scrolloff=3
  #     set showmode
  #     set showcmd
  #     set hidden
  #     set wildmenu
  #     set wildmode=list:longest
  #     set cursorline
  #     set ttyfast
  #     set nowrap
  #     set ruler
  #     set backspace=indent,eol,start
  #     set laststatus=2
  #     set clipboard=autoselect

  #     " Dir stuff
  #     set nobackup
  #     set nowritebackup
  #     set noswapfile
  #     set backupdir=~/.config/vim/backups
  #     set directory=~/.config/vim/swap

  #     " Relative line numbers for easy movement
  #     set relativenumber
  #     set rnu

  #     "" Whitespace rules
  #     set tabstop=8
  #     set shiftwidth=2
  #     set softtabstop=2
  #     set expandtab

  #     "" Searching
  #     set incsearch
  #     set gdefault

  #     "" Statusbar
  #     set nocompatible " Disable vi-compatibility
  #     set laststatus=2 " Always show the statusline
  #     let g:airline_theme='bubblegum'
  #     let g:airline_powerline_fonts = 1

  #     "" Local keys and such
  #     let mapleader=","
  #     let maplocalleader=" "

  #     "" Change cursor on mode
  #     :autocmd InsertEnter * set cul
  #     :autocmd InsertLeave * set nocul

  #     "" File-type highlighting and configuration
  #     syntax on
  #     filetype on
  #     filetype plugin on
  #     filetype indent on

  #     "" Paste from clipboard
  #     nnoremap <Leader>, "+gP

  #     "" Copy from clipboard
  #     xnoremap <Leader>. "+y

  #     "" Move cursor by display lines when wrapping
  #     nnoremap j gj
  #     nnoremap k gk

  #     "" Map leader-q to quit out of window
  #     nnoremap <leader>q :q<cr>

  #     "" Move around split
  #     nnoremap <C-h> <C-w>h
  #     nnoremap <C-j> <C-w>j
  #     nnoremap <C-k> <C-w>k
  #     nnoremap <C-l> <C-w>l

  #     "" Easier to yank entire line
  #     nnoremap Y y$

  #     "" Move buffers
  #     nnoremap <tab> :bnext<cr>
  #     nnoremap <S-tab> :bprev<cr>

  #     "" Like a boss, sudo AFTER opening the file to write
  #     cmap w!! w !sudo tee % >/dev/null

  #     let g:startify_lists = [
  #       \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
  #       \ { 'type': 'sessions',  'header': ['   Sessions']       },
  #       \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
  #       \ ]

  #     let g:startify_bookmarks = [
  #       \ '~/Projects',
  #       \ '~/Documents',
  #       \ ]

  #     let g:airline_theme='bubblegum'
  #     let g:airline_powerline_fonts = 1
  #     '';
  #    };

  ssh = {
    enable = true;
    enableDefaultConfig = false;
  #   includes = [ "/Users/${user}/.ssh/config-private" ];
    matchBlocks = {
      "*" = {
        # Set the default values we want to keep
        sendEnv = [ "LANG" "LC_*" ];
        hashKnownHosts = true;
      };
      "github.com" = {
        identitiesOnly = true;
        identityFile = [ "/Users/${user}/.ssh/id_ed25519" ];
      };
    };
  };

  tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    sensibleOnTop = false;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = power-theme;
        extraConfig = ''
           set -g @tmux_power_theme 'gold'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Use XDG data directory
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    terminal = "screen-256color";
    prefix = "C-a";
    escapeTime = 10;
    historyLimit = 50000;
    extraConfig = ''
      # Remove Vim mode delays
      set -g focus-events on

      # Enable full mouse support
      set -g mouse on

      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      # Unbind default keys
      unbind C-b
      unbind '"'
      unbind %

      # Split panes, vertical or horizontal
      bind-key x split-window -v
      bind-key v split-window -h

      # Move around panes with vim-like bindings (h,j,k,l)
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-l select-pane -R

      # Smart pane switching with awareness of Vim splits.
      # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      # Darwin-specific fix for tmux 3.5a with sensible plugin
      # This MUST be at the very end of the config
      set -g default-command "$SHELL"
      '';
    };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
  #       file = lib.mkMerge [
  #         additionalFiles
  #       ];
        stateVersion = "25.11";
      };
    };
  };
}
