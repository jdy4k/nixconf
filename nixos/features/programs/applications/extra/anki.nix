{ self, ... }: {
  flake.nixosModules.anki = { pkgs, ... }:  let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
  in 
  {
    environment.systemPackages = [
      selfpkgs.anki
    ];
  };
}
