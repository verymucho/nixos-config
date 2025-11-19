{ config, pkgs, lib, home-manager, ... }:

let
  name = "%NAME%";
  user = "%USER%";
  email = "%EMAIL%";
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
  #       file = lib.mkMerge [
  #         additionalFiles
  #       ];
        stateVersion = "25.11";
      };
      programs = {} // import ./programs.nix { inherit email name user config pkgs lib; };
      manual.manpages.enable = false;
    };
  };
}
