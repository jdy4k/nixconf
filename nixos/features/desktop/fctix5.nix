{
  flake.nixosModules.desktop = { lib, pkgs, ... }: {
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

    environment.variables = {
      XMODIFIERS = "@im=fcitx";
      GTK_IM_MODULE = lib.mkForce "";
      QT_IM_MODULE = lib.mkForce "";
    };
    environment.sessionVariables = {
      GTK_IM_MODULE = lib.mkForce "";
      QT_IM_MODULE = lib.mkForce "";
    };
  };
}
