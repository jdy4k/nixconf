{
  flake.nixosModules.applications = { pkgs, ...}: {
    environment.systemPackages = [ pkgs.imv ];
  };
}
