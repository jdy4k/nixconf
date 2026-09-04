{ ... }: {
  flake.nixosModules.system = { config, ... }: {
    networking.hostName = "${config.preferences.host.name}";
    networking.networkmanager.enable = true;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 8000 443 ];
      allowedUDPPortRanges = [
        { from = 4000; to = 4007; }
        { from = 8000; to = 8010; }
      ];
    };
  };
}
