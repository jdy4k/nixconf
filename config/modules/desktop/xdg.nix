# Portals, default applications, and user directories.
{ ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "gtk" ];
    };

  xdg.mime = {
      enable = true;
      defaultApplications = {
        # Browser
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";

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

    environment.sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };
}
