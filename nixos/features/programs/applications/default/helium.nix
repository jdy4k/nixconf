{
  flake.nixosModules.applications = {
    programs.helium = {
      enable = true;
      flags = [
        "--ozone-platform=wayland"
        "--ozone-platform-hint=auto"
        "--enable-features=UseOzonePlatform,AcceleratedVideoDecodeLinuxGL,WaylandWindowDecorations"
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
