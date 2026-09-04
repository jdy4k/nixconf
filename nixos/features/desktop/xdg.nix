# Portals, default applications, and user directories.
{ ... }: {
  flake.nixosModules.desktop = { pkgs, config, ... }: {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "gtk" ];
    };

    hjem.users."${config.preferences.user.name}" = {
      directory = "/home/${config.preferences.user.name}";
      files.".config/user-dirs.dirs" = {
        text = ''
        XDG_DOCUMENTS_DIR="$HOME/${config.preferences.xdg.documents}"
        XDG_DOWNLOAD_DIR="$HOME/${config.preferences.xdg.downloads}"
        XDG_MUSIC_DIR="$HOME/${config.preferences.xdg.music}"
        XDG_PICTURES_DIR="$HOME/${config.preferences.xdg.pictures}"
        XDG_DESKTOP_DIR="$HOME/${config.preferences.xdg.desktop}"
        XDG_PROJECTS_DIR="$HOME/${config.preferences.xdg.projects}"
        XDG_PUBLICSHARE_DIR="$HOME/${config.preferences.xdg.publicshare}"
        XDG_TEMPLATES_DIR="$HOME/${config.preferences.xdg.templates}"
        XDG_VIDEOS_DIR="$HOME/${config.preferences.xdg.videos}"
        '';
        clobber = true;
      };
    };

    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    xdg.mime = {
      enable = true;
      defaultApplications = {
        # Browser
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
        "text/html" = "librewolf.desktop";
        "application/xhtml+xml" = "librewolf.desktop";

        "inode/directory" = "pcmanfm.desktop";

        # PDF/Books
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
        "application/epub+zip" = "org.pwmt.zathura-pdf-mupdf.desktop";

        # Image
        "image/*" = "imv.desktop";

        # Video
        "video/*" = "mpv.desktop";

        # Audio
        "audio/*" = "mpv.desktop";
      };
    };
  };
}
