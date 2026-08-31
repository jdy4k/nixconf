{ ... }: {
  flake.nixosModules.system = {
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
  };
}
