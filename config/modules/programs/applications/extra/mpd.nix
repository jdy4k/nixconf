{ self, ... }: {
  flake.nixosModules.mpd = { pkgs, ... }: let
    selfpkgs = self.packages."${pkgs.system}";
    user = "jdy4k";
  in {
    environment.systemPackages = [
      selfpkgs.ncmpcpp
      pkgs.mpc
    ];

    systemd.tmpfiles.rules = [
      "d /home/${user}/.local/share/mpd           0755 ${user} users -"
      "d /home/${user}/.local/share/mpd/playlists 0755 ${user} users -"
    ];

    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };

    services.mpd = {
      enable = true;
      inherit user;

      settings = {
        restore_paused = "yes";
        auto_update = "yes";
        music_directory = "/home/${user}/local_music";
        playlist_directory = "/home/${user}/.local/share/mpd/playlists";
        db_file = "/home/${user}/.local/share/mpd/database";
        state_file = "/home/${user}/.local/share/mpd/state";
        sticker_file = "/home/${user}/.local/share/mpd/sticker.sql";
      };
    };
  };
}
