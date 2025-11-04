{
  description = "Starter Configuration with secrets for MacOS";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
    # mac-app-util.url = "github:hraban/mac-app-util";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      # url = "github:zhaofengli/nix-homebrew";
      url = "github:slickag/nix-homebrew/brew-latest-patch-1";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    # homebrew-cirruslabs = {
    #   url = "github:cirruslabs/homebrew-cli";
    #   flake = false;
    # };
    # homebrew-cloudflare = {
    #   url = "github:cloudflare/homebrew-cloudflare";
    #   flake = false;
    # };
    # homebrew-hashicorp = {
    #   url = "github:hashicorp/homebrew-tap";
    #   flake = false;
    # };
    homebrew-stash = {
      url = "github:otsge/homebrew-stash";
      flake = false;
    };
    # homebrew-wailbrew = {
    #   url = "github:wickenico/homebrew-wailbrew";
    #   flake = false;
    # };
  };
  outputs = { self, darwin, nix-homebrew, homebrew-core, homebrew-cask, homebrew-stash, home-manager, flake-utils, nixpkgs, agenix } @inputs:
    let
      user = "%USER%";
      darwinSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs darwinSystems f;
      devShell = system: let pkgs = nixpkgs.legacyPackages.${system}; in {
        default = with pkgs; mkShell {
          nativeBuildInputs = with pkgs; [ bashInteractive git age age-plugin-yubikey ];
          shellHook = with pkgs; ''
            export EDITOR=vim
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
      devShells = forAllSystems devShell;
      apps = nixpkgs.lib.genAttrs darwinSystems mkDarwinApps;

      darwinConfigurations = nixpkgs.lib.genAttrs darwinSystems (system:
        darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs // { inherit user; };
          modules = [
            # mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            # (
            #   { pkgs, config, inputs, ... }:
            #   {
            #     home-manager.sharedModules = [
            #       mac-app-util.homeManagerModules.default
            #     ];
            #   }
            # )
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
                  # "cirruslabs/homebrew-cli" = homebrew-cirruslabs;
                  # "cloudflare/homebrew-cloudflare" = homebrew-cloudflare;
                  # "hashicorp/homebrew-tap" = homebrew-hashicorp;
                  "otsge/homebrew-stash" = homebrew-stash;
                  # "wickenico/homebrew-wailbrew" = homebrew-wailbrew;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ({config, ...}: {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            })
            ./hosts/darwin
          ];
        }
      );
    };
}
