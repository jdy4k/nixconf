{ self, ... }: {
  flake.nixosModules.anki = { pkgs, ... }:  let
    selfpkgs = self.packages."${pkgs.system}";
  in 
  {
    environment.systemPackages = [
      selfpkgs.anki
    ];
  };
}
