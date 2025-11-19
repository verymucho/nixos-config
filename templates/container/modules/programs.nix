{ email, name, user, config, pkgs, lib, ... }:
{
  # direnv = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   nix-direnv.enable = true;
  # };

  zsh = {
    enable = true;
    autocd = false;
    completionInit = "autoload -U compinit && compinit -i";
    history.size = 1000000000;
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

      # Define variables for directories
      [[ -d $HOME/.local/share/bin ]] && export PATH=$HOME/.local/share/bin:$PATH

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:cd:ls:l"

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
      [[ $(whence nh) ]] && alias nh="NH_ELEVATION_PROGRAM=$HOME/bin/nix-sudo nh"
      alias sudo="sudo -H "

      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
    '';
  };

  bat = {
    enable = true;
    config = {
      color = "always";
      decorations = "always";
      italic-text = "always";
      theme = "Dracula";
    };
    extraPackages = [ pkgs.bat-extras.core ];
  };

  # fzf = {
  #   enable = true;
  #   enableZshIntegration = true;
  #   defaultOptions = [ "--style=full" ];
  # };

  git = {
    enable = true;
    ignores = [ "*.swp" "*.zwc" ".DS_Store" ];
    lfs = {
      enable = true;
    };
    settings = {
      user = {
        name = "${name}";
        email = "${email}";
      };
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

#   tmux = {
#     enable = true;
#     shell = "${pkgs.zsh}/bin/zsh";
#     sensibleOnTop = false;
#     plugins = with pkgs.tmuxPlugins; [
#       vim-tmux-navigator
#       sensible
#       yank
#       prefix-highlight
#       {
#         plugin = power-theme;
#         extraConfig = ''
#            set -g @tmux_power_theme 'gold'
#         '';
#       }
#       {
#         plugin = resurrect; # Used by tmux-continuum

#         # Use XDG data directory
#         # https://github.com/tmux-plugins/tmux-resurrect/issues/348
#         extraConfig = ''
#           set -g @resurrect-dir '$HOME/.cache/tmux/resurrect'
#           set -g @resurrect-capture-pane-contents 'on'
#           set -g @resurrect-pane-contents-area 'visible'
#         '';
#       }
#       {
#         plugin = continuum;
#         extraConfig = ''
#           set -g @continuum-restore 'on'
#           set -g @continuum-save-interval '5' # minutes
#         '';
#       }
#     ];
#     terminal = "screen-256color";
#     prefix = "C-a";
#     escapeTime = 10;
#     historyLimit = 50000;
#     extraConfig = ''
#       # Remove Vim mode delays
#       set -g focus-events on

#       # Enable full mouse support
#       set -g mouse on

#       # -----------------------------------------------------------------------------
#       # Key bindings
#       # -----------------------------------------------------------------------------

#       # Unbind default keys
#       unbind C-b
#       unbind '"'
#       unbind %

#       # Split panes, vertical or horizontal
#       bind-key x split-window -v
#       bind-key v split-window -h

#       # Move around panes with vim-like bindings (h,j,k,l)
#       bind-key -n M-k select-pane -U
#       bind-key -n M-h select-pane -L
#       bind-key -n M-j select-pane -D
#       bind-key -n M-l select-pane -R

#       # Smart pane switching with awareness of Vim splits.
#       # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
#       is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
#         | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
#       bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
#       bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
#       bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
#       bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
#       tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
#       if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
#         "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
#       if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
#         "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

#       bind-key -T copy-mode-vi 'C-h' select-pane -L
#       bind-key -T copy-mode-vi 'C-j' select-pane -D
#       bind-key -T copy-mode-vi 'C-k' select-pane -U
#       bind-key -T copy-mode-vi 'C-l' select-pane -R
#       bind-key -T copy-mode-vi 'C-\' select-pane -l

#       # Darwin-specific fix for tmux 3.5a with sensible plugin
#       # This MUST be at the very end of the config
#       set -g default-command "$SHELL"
#       '';
#     };
}