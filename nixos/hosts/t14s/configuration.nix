{ inputs, self, ... }: let
  host = "t14s";
in {
  flake.nixosConfigurations."${host}" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.helium-flake.nixosModules.default
      inputs.hjem.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.impermanence.nixosModules.impermanence
      inputs.nixvim.nixosModules.nixvim
      inputs.sops-nix.nixosModules.sops
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
      self.nixosModules.base

      self.nixosModules.applications
      self.nixosModules.cli
      self.nixosModules.services
      self.nixosModules.forticlient

      self.nixosModules.libreoffice
      self.nixosModules.mpd
      self.nixosModules.anki
    ];

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      # t14s AMD hardware
      "broadcom-bt-firmware"
      "b43-firmware"
      "xone-dongle-firmware"
      "facetimehd-calibration"
      "facetimehd-firmware"

      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

    preferences.user.name = "jdy4k";
    preferences.user.email = "jhosler02@gmail.com";
    preferences.host.name = "t14s";
    preferences.monitors = {
      eDP-1 = {
        primary = true;
        width = 1920;
        height = 1200;
        scale = 1;
        refreshRate = 60.001;
        x = 0;
        y = 0;
        enable = true;
      };
    };
    preferences.xdg = {
      documents = "documents";
      desktop = ".xdg/desktop";
      downloads = "downloads";
      music = "music";
      pictures = "pictures";
      projects = ".xdg/projects";
      publicshare = ".xdg/public";
      templates = ".xdg/templates";
      videos = "videos";
    };

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

    nixpkgs.config.allowUnfree = false;
    system.stateVersion = "23.11";
  };
}

