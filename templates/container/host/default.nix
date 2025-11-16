{ config, pkgs, ... }:
let
  user = "%USER%";
in
{
  imports = [
    ../modules
  ];
  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      interval.Hour = 4;
    };
  };
  environment.systemPackages = with pkgs; [
    vim
  ] ++ (import ../modules/packages.nix { inherit pkgs; });

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 6;
    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };
      CustomSystemPreferences = {
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.timemachine.HelperAgent" = {
          DoNotAskAgainToSetUpNewDisks = true;
        };
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ApplePressAndHoldEnabled = false;
        AppleShowScrollBars = "Always";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = true;
        NSAutomaticSpellingCorrectionEnabled = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        _HIHideMenuBar = false;
        # AppleLanguages = [ "en-US" "es-US" ];
        # AppleLocale = "en_US";

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
        "com.apple.swipescrolldirection" = false;
        "com.apple.trackpad.scaling" = 3.0;
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
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "Nlsv";
        NewWindowTarget = "Home";
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = true;
        _FXShowPosixPathInTitle = true;
        _FXEnableColumnAutoSizing = true;
        _FXSortFoldersFirst = true;
        _FXSortFoldersFirstOnDesktop = true;
      };
      magicmouse.MouseButtonMode = "TwoButton";
    };
  };
}
