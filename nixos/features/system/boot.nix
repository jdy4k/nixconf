{ lib, ... }: {
  flake.nixosModules.system = { pkgs, config, ... }: {
    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    boot = {
      plymouth = {
        enable = true;
        theme = "red_loader";
        themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "red_loader" ];
        })
      ];
      };

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "rd.systemd.show_status=auto"
      ];
      kernelModules = ["mt7921e" "coretemp" "cpuid" "v4l2loopback"];
    };

    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.displayManager.defaultSession = "niri";
    
    services.displayManager.autoLogin = {
      enable = true;
      user = "${config.preferences.user.name}";
    };
  };
}
