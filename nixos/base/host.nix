{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences = {
      host.name = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
      };
    };
  };
}
