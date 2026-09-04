{ self, ... }: {
  flake.nixosModules.mpd = { pkgs, config, ... }: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment.systemPackages = [
      selfpkgs.ncmpcpp
      pkgs.mpc
    ];

    systemd.tmpfiles.rules = [
      "d /home/${config.preferences.user.name}/.local/share/mpd           0755 ${config.preferences.user.name} users -"
      "d /home/${config.preferences.user.name}/.local/share/mpd/playlists 0755 ${config.preferences.user.name} users -"
    ];

    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };

    services.mpd = {
      enable = true;
      settings = {
        restore_paused = "yes";
        auto_update = "yes";
        music_directory = "/home/${config.preferences.user.name}/local_music";
        # playlist_directory = "/home/${config.preferences.user.name}/local_music";
        # db_file = "/home/${config.preferences.user.name}/local_music";
        # state_file = "/home/${config.preferences.user.name}/local_music";
        # sticker_file = "/home/${config.preferences.user.name}/local_music";
      };
    };
  };
}
