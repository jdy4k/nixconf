{ inputs, self, pkgs, ... }: let
  selfpkgs = self.packages."${pkgs.system}";
  user = "jdy4k";
  host = "t14s";
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
      ./_tlp.nix
      ./_optimization.nix
      
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
        XDG_DOCUMENTS_DIR="$HOME/local_documents"
        XDG_DOWNLOAD_DIR="$HOME/local_downloads"
        XDG_MUSIC_DIR="$HOME/local_music"
        XDG_PICTURES_DIR="$HOME/local_pictures"
        XDG_DESKTOP_DIR="$HOME/.desktop"
      '';
    };

    environment.sessionVariables = {
      NH_FLAKE = "/home/${user}/nixconf";
    };

    nixpkgs.config.allowUnfree = false;
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      # t14s AMD hardware
      "broadcom-bt-firmware"
      "b43-firmware"
      "xone-dongle-firmware"
      "facetimehd-calibration"
      "facetimehd-firmware"
      "cnijfilter2" # Pixma printer drivers
    ];

    networking.hostName = "${host}";

    ### Work around for broken key

    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          shift = {
            home = "backslash";
            end  = "macro(S-backslash)";
          };
        };
      };
    };

    ### Auto login + launch niri session

    # services.greetd = {
    #   enable = true;
    #   settings = {
    #     initial_session = {
    #       command = "${selfpkgs.niri}/bin/niri-session";
    #       user = "${user}";
    #     };
    #     default_session = {
    #       command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time -cmd ${selfpkgs.niri}/bin/niri-session";
    #       user = "greeter";
    #     };
    #   };
    # };

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
