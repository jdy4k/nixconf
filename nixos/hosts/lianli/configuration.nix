{ inputs, self, ... }: let
  host = "lianli";
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

  flake.nixosModules."host-${host}" = { ... }: {
    imports = [
      ./_hardware-configuration.nix
      ./_disk-configuration.nix
      ./_impermanence.nix
      ./_optimization.nix

      self.nixosModules.system
      self.nixosModules.desktop
      self.nixosModules.base

      self.nixosModules.applications
      self.nixosModules.cli
      self.nixosModules.services
      self.nixosModules.mullvad
      self.nixosModules.forticlient

      self.nixosModules.gaming
      self.nixosModules.discord

      self.nixosModules.libreoffice
      self.nixosModules.gimp
      self.nixosModules.mpd
      self.nixosModules.anki
    ];

    preferences.user.name = "jdy4k";
    preferences.user.email = "jhosler02@gmail.com";
    preferences.host.name = "lianli";
    preferences.monitors = {
      DP-2 = {
        primary = true;
        width = 3840;
        height = 2160;
        scale = 2;
        refreshRate = 59.997;
        x = 1920;
        y = 0;
        enable = true;
      };
      DP-3 = {
        primary = true;
        width = 1920;
        height = 1080;
        scale = 1;
        refreshRate = 179.998;
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

    # Focusrite Scarlett 2i2 4th Gen (USB pid 0x8219 — 0x8212 is 3rd gen)
    boot.extraModprobeConfig = ''
      options snd_usb_audio vid=0x1235 pid=0x8219 device_setup=1
    '';

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
