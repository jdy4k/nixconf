# Niri desktop: compositor, terminal, auto-login, and session variables.
{ self, ... }: {
  flake.nixosModules.desktop = { pkgs, lib, ... }: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.niri.enable = true;
    programs.niri.package = selfpkgs.niri;

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
