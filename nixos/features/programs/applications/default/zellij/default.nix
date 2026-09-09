{ ... }: {
  flake.nixosModules.applications = { pkgs, config, ...}: {
    environment.systemPackages = [ pkgs.zellij ];
    hjem.users.${config.preferences.user.name} = {
      directory = "/home/${config.preferences.user.name}";
      files.".config/zellij" = {
        source = ./config;
        clobber = true;
      };
    };
  };
}
