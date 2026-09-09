{
  flake.nixosModules.gaming = { pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      steam-run
      lutris
    ];
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraArgs = "-cef-disable-gpu-compositing";
        extraEnv = {
          PULSE_SERVER = "/nonexistent";
          QT_QPA_PLATFORM = "xcb";
        };
        extraProfile = ''
          unset NIXOS_OZONE_WL
          unset GDK_BACKEND
        '';
      };
      extest.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = false;
    };
    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
      enableWsi = true;
      capSysNice = false;
    };
    security.allowUserNamespaces = true;
  };
}
