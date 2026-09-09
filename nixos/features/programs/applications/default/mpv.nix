{ self, ... }: {
  flake.nixosModules.applications = { pkgs, ... }:  let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in 
  {
    environment.systemPackages = [
      selfpkgs.mpv
    ];
  };
}
