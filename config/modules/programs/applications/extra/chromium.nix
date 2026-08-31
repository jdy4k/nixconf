{
  flake.nixosModules.chromium = {pkgs, ...}: {
    programs.chromium.enable = true;
    environment.systemPackages = [
      (pkgs.ungoogled-chromium.override {
        commandLineArgs = builtins.concatStringsSep " " [
          "--ozone-platform-hint=auto"
          "--force-dark-mode"
          "--enable-features=WebUIDarkMode"
        ];
      })
    ];
  };
}
