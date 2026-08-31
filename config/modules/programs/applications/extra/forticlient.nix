{ self, ... }: {
  flake.nixosModules.forticlient = { pkgs, ...}: let
    selfpkgs = self.packages."${pkgs.system}";
  in
  {
    environment.systemPackages = [
      selfpkgs.forticlient
    ];
  };
}
