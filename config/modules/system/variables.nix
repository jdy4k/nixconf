{ ... }: {
  flake.nixosModules.system = { ... }: {
    environment.sessionVariables = {
      EDITOR = "nvim";
    };
  };
}
