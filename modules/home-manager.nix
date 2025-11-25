{ config, pkgs, lib, home-manager, ... }:

let
  name = "Winst";
  user = "AG";
  email = "67540662+verymucho@users.noreply.github.com";
  # Define the content of your file as a derivation
  # myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
  #   #!/bin/sh
  #   emacsclient -c -n &
  # '';
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
    # masApps = {
    #   "developer" = 640199958;
    #   "imazing profile editor" = 1487860882;
    #   "mediainfo" = 510620098;
    #   "previewtext" = 1660037028;
    #   "testflight" = 899247664;
    #   "wireguard" = 1451685025;
    # };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        # file = lib.mkMerge [
        #   additionalFiles
        #   { "emacs-launcher.command".source = myEmacsLauncher; }
        # ];
        stateVersion = "25.11";
      };
      programs = {} // import ./programs.nix { inherit email name user config pkgs lib; };
      fonts.fontconfig.enable = true;
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  # local.dock = {
  #   enable = false;
  #   username = user;
  #   entries = [
  #     { path = "/Applications/Safari.app/"; }
  #     { path = "/System/Applications/Messages.app/"; }
  #     { path = "/System/Applications/Notes.app/"; }
  #     { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
  #     { path = "/System/Applications/Music.app/"; }
  #     { path = "/System/Applications/Photos.app/"; }
  #     { path = "/System/Applications/Photo Booth.app/"; }
  #     { path = "/System/Applications/System Settings.app/"; }
  #     { path = "${pkgs.jetbrains.phpstorm}/Applications/PhpStorm.app/"; }
  #     {
  #       path = toString myEmacsLauncher;
  #       section = "others";
  #     }
  #     {
  #       path    = "${config.users.users.${user}.home}/.local/share/";
  #       section = "others";
  #       options = "--sort name --view grid --display folder";
  #     }
  #     {
  #       path = "${config.users.users.${user}.home}/Downloads";
  #       section = "others";
  #       options = "--sort name --view grid --display stack";
  #     }
  #   ];
  # };
}
