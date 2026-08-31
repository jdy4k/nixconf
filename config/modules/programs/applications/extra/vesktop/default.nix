{
  flake.nixosModules.discord = {pkgs, lib, ...}: {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      # "discord"
      "vesktop"
    ];
    environment.systemPackages = [
      pkgs.vesktop
      # pkgs.discord
    ];
    hjem.users.jdy4k = {
      directory = "/home/jdy4k";
      files = {
        ".config/vesktop/themes/gruvbox.theme.css".source = ./gruvbox.theme.css;
        ".config/vesktop/settings/settings.json".source = ./settings.json;
      };
    };
  };
}
