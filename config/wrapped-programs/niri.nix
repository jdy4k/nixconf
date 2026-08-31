{
  inputs,
  self,
  ...
}: {
  flake.wrapperModules.niri = { config, lib, ...}: {

    options.terminal = lib.mkOption {
      type = lib.types.str;
      default = "alacritty";
    };

    config = {
      # nixpkgs installs the unit under lib/, not share/. Also disable
      # hot-reload: upstream appends to share/systemd/user/niri.service,
      # which does not exist on current niri and breaks the wrap.
      filesToPatch = [
        "lib/systemd/user/niri.service"
        "share/wayland-sessions/*.desktop"
      ];
      disableConfigHotReload = true;
      passthru.providedSessions = [ "niri" ];

      settings = let
        noctaliaExe = lib.getExe self.packages.${config.pkgs.stdenv.hostPlatform.system}.noctalia-shell;
      in {
        prefer-no-csd = _: {};
        
        cursor = {
          xcursor-theme = "Adwaita";
          xcursor-size = 24;
        };
        
        hotkey-overlay = {
            skip-at-startup = _: {};
        };

        debug = {
          disable-cursor-plane = _: {};
        };

        input = {
          focus-follows-mouse = _: {};

          keyboard = {
            xkb = {
              layout = "us,jp";
              options = "grp:alt_shift_toggle,caps:escape";
            };
            repeat-rate = 40;
            repeat-delay = 250;
          };

          touchpad = {
            natural-scroll = _: {};
            tap = _: {};
          };

          mouse = {
            accel-profile = "flat";
          };

          tablet = {
            map-to-output = "HDMI-A-1";
          };
          touch = {
            map-to-output = "HDMI-A-1";
          };
        };

        binds = {
          "Mod+Return".spawn = config.terminal;

          "Mod+Q".close-window = _: {};
          "Mod+F".maximize-column = _: {};
          "Mod+G".fullscreen-window = _: {};
          "Mod+Shift+F".toggle-window-floating = _: {};
          "Mod+C".center-column = _: {};

          "Mod+Left".focus-column-left = _: {};
          "Mod+Right".focus-column-right = _: {};
          "Mod+Up".focus-window-up = _: {};
          "Mod+Down".focus-window-down = _: {};

          "Mod+Shift+Left".move-column-left = _: {};
          "Mod+Shift+Right".move-column-right = _: {};
          "Mod+Shift+Up".move-window-up = _: {};
          "Mod+Shift+Down".move-window-down = _: {};

          "Mod+1".focus-workspace = "w0";
          "Mod+2".focus-workspace = "w1";
          "Mod+3".focus-workspace = "w2";
          "Mod+4".focus-workspace = "w3";
          "Mod+5".focus-workspace = "w4";
          "Mod+0".focus-workspace = "wl";

          "Mod+Shift+1".move-column-to-workspace = "w0";
          "Mod+Shift+2".move-column-to-workspace = "w1";
          "Mod+Shift+3".move-column-to-workspace = "w2";
          "Mod+Shift+4".move-column-to-workspace = "w3";
          "Mod+Shift+5".move-column-to-workspace = "w4";
          "Mod+Shift+0".move-column-to-workspace = "wl";

          "Mod+S".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
          "XF86AudioMute".spawn-sh = ''${config.pkgs.alsa-utils}/bin/amixer sset Capture toggle'';
          
          "XF86AudioPlay".spawn-sh  = ''${lib.getExe config.pkgs.playerctl} play-pause'';
          "XF86AudioPause".spawn-sh = ''${lib.getExe config.pkgs.playerctl} play-pause'';
          "XF86AudioNext".spawn-sh  = ''${lib.getExe config.pkgs.playerctl} next'';
          "XF86AudioPrev".spawn-sh  = ''${lib.getExe config.pkgs.playerctl} previous'';

          "Mod+XF86AudioPlay".spawn-sh  = ''${lib.getExe config.pkgs.mpc} toggle'';
          "Mod+XF86AudioPause".spawn-sh = ''${lib.getExe config.pkgs.mpc} toggle'';
          "Mod+XF86AudioNext".spawn-sh  = ''${lib.getExe config.pkgs.mpc} next'';
          "Mod+XF86AudioPrev".spawn-sh  = ''${lib.getExe config.pkgs.mpc} prev'';

          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 1%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 1%-";
          
          "XF86MonBrightnessUp".spawn-sh   = "${lib.getExe config.pkgs.brightnessctl} set +1%";
          "XF86MonBrightnessDown".spawn-sh = "${lib.getExe config.pkgs.brightnessctl} set -1%";

          "Mod+Ctrl+H".set-column-width  = "-5%";
          "Mod+Ctrl+L".set-column-width  = "+5%";
          "Mod+Ctrl+J".set-window-height = "-5%";
          "Mod+Ctrl+K".set-window-height = "+5%";

          "Mod+WheelScrollDown".focus-column-left = _: {};
          "Mod+WheelScrollUp".focus-column-right = _: {};
          "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: {};
          "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: {};

          "Print".screenshot-screen = _: {};
          "Mod+Print".screenshot = _: {};
          "Alt+Print".screenshot-window = _: {};

          "Mod+E".spawn-sh = ''${config.pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe config.pkgs.swappy} -f -'';
       };

        layout = {
          gaps = 12;
          background-color = "#1a1a1a";

          focus-ring = {
            width = 1;
            active-color = "#${self.themeNoHash.base02}";
          };
        };

        workspaces = let
          settings = {layout.gaps = 8;};
          primary = settings // {open-on-output = "DP-2";};
          secondary = settings // {open-on-output = "DP-3";};
        in {
          w0 = primary;
          w1 = primary;
          w2 = primary;
          w3 = primary;
          w4 = primary;
          wl = secondary;
        };

        outputs = {
          "DP-3" = {
            mode = "1920x1080@179.998";
            scale = 1;
            position = _: {props = {x = 0; y = 0;};};
          };
          "DP-2" = {
            mode = "3860x2160@60.000";
            scale = 2;
            position = _: {props = {x = 1080; y = 0;};};
          };
        };

        xwayland-satellite.path =
          lib.getExe config.pkgs.xwayland-satellite;

        screenshot-path = "~/local_pictures/screenshots/%Y-%m-%d %H-%M-%S.png";

        spawn-at-startup = [
          ["${config.pkgs.dbus}/bin/dbus-update-activation-environment" "--systemd" "WAYLAND_DISPLAY" "DISPLAY" "XDG_CURRENT_DESKTOP"]
          noctaliaExe
        ];
      };
    };
  };

  perSystem = {pkgs, ...}: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [self.wrapperModules.niri];
    };
  };
}
