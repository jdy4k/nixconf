{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences = {
      xdg = {
        documents = lib.mkOption {
          type = lib.types.str;
          default = "Documents";
        };
        desktop = lib.mkOption {
          type = lib.types.str;
          default = "Desktop";
        };
        downloads = lib.mkOption {
          type = lib.types.str;
          default = "Downloads";
        };
        music = lib.mkOption {
          type = lib.types.str;
          default = "Music";
        };
        pictures = lib.mkOption {
          type = lib.types.str;
          default = "Pictures";
        };
        projects = lib.mkOption {
          type = lib.types.str;
          default = "Projects";
        };
        publicshare = lib.mkOption {
          type = lib.types.str;
          default = "Public";
        };
        templates = lib.mkOption {
          type = lib.types.str;
          default = "Templates";
        };
        videos = lib.mkOption {
          type = lib.types.str;
          default = "Videos";
        };

      };
    };
  };
}
