{ self, ... }: {
  flake.nixosModules.applications = { pkgs, ... }:  let
    selfpkgs = self.packages."${pkgs.system}";
  in 
  {
    environment.systemPackages = [
      selfpkgs.zathura
    ];
  };
}
