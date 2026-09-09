{ ... }: {
  flake.nixosModules.desktop = { pkgs, lib, config, ... }: let
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
      # platformTheme = "qt5ct";
      #style = "kvantum";
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

  #hjem.users.${config.preferences.user.name} = {
  #  enable = true;
    
    # Write the Kvantum config file directly into ~/.config/Kvantum/kvantum.kvconfig
    # xdg.config.files = {
    #   "Kvantum/kvantum.kvconfig".text = ''
    #     [General]
    #     theme=Gruvbox-Dark-Brown
    #   '';

    #   "Kvantum/Gruvbox-Dark-Brown".source =
    #   "${pkgs.gruvbox-kvantum}/share/Kvantum/Gruvbox-Dark-Brown";

    #   # Configure qt5ct to use Kvantum
    #   "qt5ct/qt5ct.conf".text = ''
    #     [Appearance]
    #     style=kvantum
    #   '';

    #   # Configure qt6ct to use Kvantum
    #   "qt6ct/qt6ct.conf".text = ''
    #     [Appearance]
    #     style=kvantum
    #   '';
    # };
    #};

    environment.systemPackages = [
      theme-package
      icon-theme-package

      #pkgs.gruvbox-kvantum
      #pkgs.libsForQt5.qt5ct
      #pkgs.qt6Packages.qt6ct
      #pkgs.libsForQt5.qtstyleplugin-kvantum
      #pkgs.qt6Packages.qtstyleplugin-kvantum

      pkgs.adwaita-icon-theme
      pkgs.gtk3
      pkgs.gtk4
    ];
  };
}
