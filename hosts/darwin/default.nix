{ config, pkgs, ... }:
let
  user = "admin";
  myEmacs = import ../../modules/darwin/emacs.nix { inherit pkgs; };
in
{
  imports = [
    ../../modules/darwin
  ];
  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://cl-nix-lite.cachix.org" "https://cache.nixos.org/" "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "cl-nix-lite.cachix.org-1:ab6+b0u2vxymMLcZ5DDqPKnxz0WObbMszmC+BDBHpFc=" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  environment.systemPackages = with pkgs; [
    myEmacs
  ] ++ (import ../../modules/darwin/packages.nix { inherit pkgs; });

  # launchd.user.agents = {
  #   emacs = {
  #     path = [ config.environment.systemPath ];
  #     serviceConfig = {
  #       KeepAlive = true;
  #       ProgramArguments = [
  #         "/bin/sh"
  #         "-c"
  #         "/bin/wait4path ${pkgs.emacs}/bin/emacs && exec ${pkgs.emacs}/bin/emacs --fg-daemon"
  #         "{ osascript -e 'display notification \"Attempting to start Emacs...\" with title \"Emacs Launch\"'; /bin/wait4path ${pkgs.emacs}/bin/emacs && { ${pkgs.emacs}/bin/emacs --fg-daemon; if [ $? -eq 0 ]; then osascript -e 'display notification \"Emacs has started.\" with title \"Emacs Launch\"'; else osascript -e 'display notification \"Failed to start Emacs.\" with title \"Emacs Launch\"' >&2; fi; } } &> /tmp/emacs_launch.log"
  #       ];
  #       StandardErrorPath = "/tmp/emacs.err.log";
  #       StandardOutPath = "/tmp/emacs.out.log";
  #     };
  #   };
  # };

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 6;
    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };
      CustomSystemPreferences = {
        "com.apple.timemachine.HelperAgent" = {
          DoNotAskAgainToSetUpNewDisks = true;
        };
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ApplePressAndHoldEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        KeyRepeat = 2; # Values: 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # Values: 120, 94, 68, 35, 25, 15

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.swipescrolldirection" = false;
      };
      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 48;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
        _FXSortFoldersFirstOnDesktop = true;
      };
      magicmouse.MouseButtonMode = "TwoButton";
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
  };
}
