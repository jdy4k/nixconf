{
  flake.nixosModules.desktop = {pkgs, ...}: {      
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-rime
        fcitx5-gtk
      ];
      fcitx5.waylandFrontend = true;
      fcitx5.ignoreUserConfig = true;
      fcitx5.settings = {
        globalOptions = {
          "Hotkey/TriggerKeys"."0" = "Control+space";
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
          "Groups/0/Items/2".Name = "rime";
        };
      };
    };

    systemd.services.fcitx5-daemon = {
      description = "Fcitx5 Input Method Editor";
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      requisite = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.fcitx5}/bin/fcitx5 -d --replace";
        Restart = "on-failure";
      };
    };

    environment.sessionVariables = {
      XMODIFIERS = "@im=fcitx";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
    };
  };
}
