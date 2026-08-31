{ inputs, self, ... }: let
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

  flake.nixosModules."host-${host}" = { config, lib, ... }: {
    imports = [
      ./_hardware-configuration.nix
      ./_disk-configuration.nix
      ./_impermanence.nix
      ./_optimization.nix

      self.nixosModules.system
      self.nixosModules.desktop

      self.nixosModules.applications
      self.nixosModules.cli
      self.nixosModules.services
      self.nixosModules.mullvad

      self.nixosModules.gaming
      self.nixosModules.discord

      self.nixosModules.libreoffice
    ];

    users.users."${user}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "gamemode" ];
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
      "cnijfilter2" # Pixma printer drivers
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

    networking.hostName = "${host}";

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = lib.getExe' config.programs.niri.package "niri-session";
        user = user;
      };
    };
    # Focusrite Scarlett 2i2 4th Gen (USB pid 0x8219 — 0x8212 is 3rd gen)
    boot.extraModprobeConfig = ''
      options snd_usb_audio vid=0x1235 pid=0x8219 device_setup=1
    '';
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
