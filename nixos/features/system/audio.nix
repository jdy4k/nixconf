{ ... }: {
  flake.nixosModules.system = { pkgs, ... }: {
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pwvucontrol
      alsa-utils
      easyeffects
      lsp-plugins
      calf
    ];
    environment.variables.LV2_PATH =
      "/run/current-system/sw/lib/lv2";
  };
}
