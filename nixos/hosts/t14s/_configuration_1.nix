{ inputs, self, pkgs, ... }: let
  user = "jdy4k";
  host = "lianli";
in {
  flake.nixosConfigurations."${host}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.hjem.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.impermanence.nixosModules.impermanence
      self.nixosModules."host-${host}"
    ];
  };

  flake.nixosModules."host-${host}" = { lib, ... }: {
    
    imports = [
      ./_hardware-configuration.nix
      ./_disk-configuration.nix
      ./_impermanence.nix
      ./_optimization.nix
      ./_tlp.nix
      
      self.nixosModules.system
      self.nixosModules.desktop
      
      self.nixosModules.applications
      self.nixosModules.cli
      self.nixosModules.services
    ];

    users.users."${user}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      initialHashedPassword = "$y$j9T$65Xrap.UjdKYFNZ3RV9Wj/$lhSQnO8PCobbQE3Ok92yzWA2cTmBYwTN/MpnzTrMzB5";
    };

    hjem.users."${user}" = {
      directory = "/home/${user}";
      files.".config/user-dirs.dirs".text = ''
        XDG_DOCUMENTS_DIR  = "${config.preferences.xdg.documents}"
        XDG_DOWNLOAD_DIR   = "${config.preferences.xdg.downloads}"
        XDG_MUSIC_DIR      = "${config.preferences.xdg.music}"
        XDG_PICTURES_DIR   = "${config.preferences.xdg.pictures}"
        XDG_DESKTOP_DIR    = "${config.preferences.xdg.desktop}"
      '';
    };

    environment.sessionVariables = {
      NH_FLAKE = "/home/${user}/nixconf";
    };

    nixpkgs.config.allowUnfree = false;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      # t14s AMD hardware
      "cnijfilter2" # Pixma printer drivers
    ];

    networking.hostName = "${host}";

    ### Auto login + launch niri session

    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${self.packages.${pkgs.stdenv.hostPlatform.system}.niri}/bin/niri-session";
          user = "${user}";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${self.packages.${pkgs.stdenv.hostPlatform.system}.niri}/bin/niri-session";
          user = "greeter";
        };
      };
    };

    ### DISK

    boot.initrd.luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-partlabel/luks";
        allowDiscards = true;
        preLVM = true;
      };
    };
  
    services.btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };

    console.keyMap = "us";

    system.stateVersion = "23.11";
  };
}
