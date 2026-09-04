{ self, ... }: {
  flake.nixosModules.forticlient = { pkgs, ...}: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in
  {
    environment.systemPackages = [
      selfpkgs.forticlient
    ];
  };
}
