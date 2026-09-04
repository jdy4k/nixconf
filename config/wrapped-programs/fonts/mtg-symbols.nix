{ ... }: {
  perSystem = { pkgs, ... }: let
    mtg-symbols = pkgs.stdenv.mkDerivation {
      pname = "MTG Symbols";
      version = "v0";
      src = pkgs.fetchgit {
        url = "https://github.com/andrewgioia/mana/";
        rev = "6ca9e696d3bda2519dcf3eebd96598f84ad9ddd8";
        hash = "sha256-SKcJI0NzRCIt4hE7LGYor7ug95hnTFKpsPa4zA8L5ds=";
        sparseCheckout = [ "fonts" ];
      };
      dontBuild = true;
      installPhase = ''
        mkdir -p $out/share/fonts/mtg-symbols
        cp fonts/* $out/share/fonts/mtg-symbols
      '';
    };
  in {
    packages.mtg-symbols = mtg-symbols;
  };
}
