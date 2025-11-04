{ user, config, pkgs, ... }:

let
  #  githubPublicKey = "ssh-ed25519 AAAA...";
  xdg_configHome = "${config.users.users.${user}.home}/.config";
  xdg_dataHome   = "${config.users.users.${user}.home}/.local/share";
  xdg_stateHome  = "${config.users.users.${user}.home}/.local/state"; in
{

  # ".ssh/id_github.pub" = {
  #   text = githubPublicKey;
  # };

  # Initializes Emacs with org-mode so we can tangle the main config
  ".emacs.d/init.el" = {
    text = builtins.readFile ./config/emacs/init.el;
  };

  # IMPORTANT: The Emacs configuration expects a config.org file at ~/.config/emacs/config.org
  # You can either:
  # 1. Copy the provided config.org to ~/.config/emacs/config.org
  # 2. Set EMACS_CONFIG_ORG environment variable to point to your config.org location
  # 3. Uncomment below to have Nix manage the file:
  #
  ".config/emacs/config.org" = {
    text = builtins.readFile ./config/emacs/config.org;
  };

  # Raycast script so that "Run Emacs" is available and uses Emacs daemon
  "${xdg_dataHome}/bin/emacsclient" = {
    executable = true;
    text = ''
      #!/bin/zsh
      #
      # Required parameters:
      # @raycast.schemaVersion 1
      # @raycast.title Run Emacs
      # @raycast.mode silent
      #
      # Optional parameters:
      # @raycast.packageName Emacs
      # @raycast.icon ${xdg_dataHome}/img/icons/Emacs.icns
      # @raycast.iconDark ${xdg_dataHome}/img/icons/Emacs.icns

      if [[ $1 = "-t" ]]; then
        # Terminal mode
        ${pkgs.emacs}/bin/emacsclient -t $@
      else
        # GUI mode
        ${pkgs.emacs}/bin/emacsclient -c -n $@
      fi
    '';
  };
  
  # Script to import Drafts into Emacs org-roam
  "${xdg_dataHome}/bin/import-drafts" = {
    executable = true;
    text = ''
      #!/bin/sh

      for f in ${xdg_stateHome}/drafts/*
      do
        if [[ ! "$f" =~ "done" ]]; then
          echo "Importing $f"
          filename="$(head -c 10 $f)"
          output="${xdg_dataHome}/org-roam/daily/$filename.org"
          echo '\n' >> "$output"
          tail -n +3 $f >> "$output"
          mv $f done
        fi
      done
    '';
  };
}
