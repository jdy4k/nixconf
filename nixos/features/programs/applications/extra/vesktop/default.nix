{
  flake.nixosModules.discord = {pkgs, lib, config, ...}: {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vesktop"
    ];
    environment.systemPackages = [
      pkgs.vesktop
    ];
    hjem.users."${config.preferences.user.name}" = {
      directory = "/home/${config.preferences.user.name}";
      files = {
        ".config/vesktop/themes/gruvbox.theme.css".source = ./gruvbox.theme.css;
        ".config/vesktop/settings/settings.json".source = ./settings.json;
      };
    };
  };
}
