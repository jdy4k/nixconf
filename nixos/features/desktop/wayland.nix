# Niri desktop: compositor, terminal, auto-login, and session variables.
{ inputs, self, ... }: {
  flake.nixosModules.desktop = { pkgs, config, ... }: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      imports = [
        self.wrapperModules.niri
        { 
          monitors = config.preferences.monitors; 
          screenshot_dir = config.preferences.xdg.pictures; 
        }
      ];
    };
  in {
    programs.niri.enable = true;
    programs.niri.package = niri;

    environment.systemPackages = [
      selfpkgs.kitty
      selfpkgs.fish
      pkgs.pcmanfm
    ];

    environment.sessionVariables = {
      NIXOS_XDG_OPEN_USE_PORTAL = "1";
      QT_QPA_PLATFORM = "wayland";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };
}
