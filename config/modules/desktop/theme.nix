{ ... }: {
  flake.nixosModules.desktop = { pkgs, lib, ... }: let
    # Note: pkgs.gruvbox-dark-gtk takes no variant arguments, and the
    # variant-capable gruvbox-gtk-theme was removed from nixpkgs
    # (gtk-engine-murrine is gone). "gruvbox-dark" is the installed name.
    theme-name = "gruvbox-dark";
    theme-package = pkgs.gruvbox-dark-gtk;

    icon-theme-name = "Gruvbox-Plus-Dark";
    icon-theme-package = pkgs.gruvbox-plus-icons;

    gtksettings = ''
      [Settings]
      gtk-icon-theme-name = ${icon-theme-name}
      gtk-theme-name = ${theme-name}
      gtk-application-prefer-dark-theme = true
    '';
  in {
    environment.etc = {
      "xdg/gtk-3.0/settings.ini".text = gtksettings;
      "xdg/gtk-4.0/settings.ini".text = gtksettings;
    };

    environment.variables = {
      GTK_THEME = theme-name;
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "24";
    };

    # Dark Qt apps without a full Qt theme (no gruvbox Qt style exists in nixpkgs)
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    programs.dconf = {
      enable = lib.mkDefault true;
      profiles.user.databases = [
        {
          lockAll = false;
          settings = {
            "org/gnome/desktop/interface" = {
              gtk-theme = theme-name;
              icon-theme = icon-theme-name;
              color-scheme = "prefer-dark";
              cursor-theme = "Adwaita";
              cursor-size = lib.gvariant.mkUint32 24;
            };
          };
        }
      ];
    };

    environment.systemPackages = [
      theme-package
      icon-theme-package

      pkgs.adwaita-icon-theme
      pkgs.gtk3
      pkgs.gtk4
    ];
  };
}
