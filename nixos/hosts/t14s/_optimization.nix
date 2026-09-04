# Application tuning for the T14s Gen 3 AMD (Ryzen 6000 / Radeon 680M iGPU).
{ pkgs, ... }: {
  environment.sessionVariables = {
    # VA-API/VDPAU hardware video decode via Mesa (mpv, librewolf, ffmpeg)
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";

    # Native Wayland for Electron/Chromium apps and Firefox/LibreWolf
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = [
    pkgs.libva-utils
  ];
}
