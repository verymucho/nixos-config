{
  description = "My Main Configuration for MacOS";

  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-homebrew.url = "github:slickag/nix-homebrew/brew-latest-patch-1";
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    _1password-shell-plugins = {
      url = "github:1Password/shell-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
    #   inputs.cl-nix-lite.url = "github:verymucho/cl-nix-lite/main";
    #   inputs.nixpkgs.follows = "nixpkgs";
    };
    prefmanager = {
      url = "github:malob/prefmanager";
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-cirruslabs = {
      url = "github:cirruslabs/homebrew-cli";
      flake = false;
    };
    homebrew-hashicorp = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
    homebrew-stash = {
      url = "github:otsge/homebrew-stash";
      flake = false;
    };
    homebrew-wailbrew = {
      url = "github:wickenico/homebrew-wailbrew";
      flake = false;
    };
  };

  outputs = inputs@{ self, darwin, nix-homebrew, homebrew-core, homebrew-cask, homebrew-cirruslabs, homebrew-hashicorp, homebrew-stash, homebrew-wailbrew, home-manager, mac-app-util, prefmanager, flake-compat, flake-utils, nixpkgs, ... }:
    let
      user = "AG";
      _1password-shell-plugins = inputs._1password-shell-plugins.hmModules.default;
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs darwinSystems f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git ];
          shellHook = with pkgs; ''
            export EDITOR=nano
          '';
        };
      };
      mkApp = scriptName: system: {
        type = "app";
        program = "${(nixpkgs.legacyPackages.${system}.writeScriptBin scriptName ''
          #!/usr/bin/env bash
          PATH=${nixpkgs.legacyPackages.${system}.git}/bin:$PATH
          echo "Running ${scriptName} for ${system}"
          exec ${self}/apps/${system}/${scriptName}
        '')}/bin/${scriptName}";
      };
      mkDarwinApps = system: {
        "apply" = mkApp "apply" system;
        "build" = mkApp "build" system;
        "build-switch" = mkApp "build-switch" system;
        "clean" = mkApp "clean" system;
        "copy-keys" = mkApp "copy-keys" system;
        "create-keys" = mkApp "create-keys" system;
        "check-keys" = mkApp "check-keys" system;
        "rollback" = mkApp "rollback" system;
      };
    in
    {
      templates = {
        container = {
          path = ./templates/container;
          description = "Basic container configuration";
        };
        main = {
          path = ./templates/main;
          description = "My main configuration";
        };
        starter = {
          path = ./templates/starter;
          description = "Starter configuration without secrets";
        };
        starter-with-secrets = {
          path = ./templates/starter-with-secrets;
          description = "Starter configuration with secrets";
        };
      };
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs // { inherit user; };
          modules = [
            mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            (
              { pkgs, config, inputs, ... }:
              {
                home-manager.sharedModules = [
                  _1password-shell-plugins
                  mac-app-util.homeManagerModules.default
                ];
              }
            )
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                inherit user;
                enable = true;
                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                # enableRosetta = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "cirruslabs/homebrew-cli" = homebrew-cirruslabs;
                  "hashicorp/homebrew-tap" = homebrew-hashicorp;
                  "otsge/homebrew-stash" = homebrew-stash;
                  "wickenico/homebrew-wailbrew" = homebrew-wailbrew;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ({config, ...}: {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            })
            ./darwin
          ];
        }
      );
    };
}
