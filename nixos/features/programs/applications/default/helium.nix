{ inputs, ... }: {
  flake.nixosModules.applications = { pkgs, ...}: {
    nixpkgs.overlays = [ inputs.helium-flake.overlays.default ];
    programs.helium = {
      enable = true;
      package = pkgs.helium.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.qt6.qtbase ];
        preFixup = old.preFixup + ''
        gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${pkgs.qt6.qtbase}/lib")
        '';
      });
      flags = [
        "--ozone-platform=wayland"
        "--ozone-platform-hint=auto"
        "--enable-features=UseOzonePlatform,AcceleratedVideoDecodeLinuxGL,WaylandWindowDecorations"
        "--password-store=basic"
      ];
      policies = {
        "BrowserSignin" = 0;
        "PasswordManagerEnabled" = true;
        "SyncDisabled" = true;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [ "en-US" ];
      };
    };
  };
}
