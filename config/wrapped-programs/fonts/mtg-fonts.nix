{ ... }: {
  perSystem = { pkgs, ... }: let
    mtg-fonts = pkgs.stdenv.mkDerivation {
      pname = "MTG Fonts";
      version = "v0";
      src = pkgs.fetchgit {
        url = "https://github.com/joshbirnholz/cardconjurer";
        rev = "d3c6706692898d596ec6a5be0be44f63062c9e12";
        hash = "sha256-0JagH3uPvjKSl8wCPQ+Zd58Ds0EDqIaqubbonx5BhMk=";
        sparseCheckout = [ "fonts" ];
      };
      dontBuild = true;
      installPhase = ''
        mkdir -p $out/share/fonts/mtg-fonts
        cp -r fonts/ $out/share/fonts/mtg-fonts
      '';
    };
  in {
    packages.mtg-fonts = mtg-fonts;
  };
}
