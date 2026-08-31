{ ... }: {
  flake.nixosModules.services = { ... }: {
    security.polkit.enable = true;

    programs.corectrl.enable = true;
    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    services.flatpak.enable = true;
    services.udisks2.enable = true;
  };
}
