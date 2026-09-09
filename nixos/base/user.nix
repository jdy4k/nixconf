{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "jdy4k";
      };
      user.email = lib.mkOption {
        type = lib.types.str;
        default = "default@.example.com";
      };
    };
  };
}
