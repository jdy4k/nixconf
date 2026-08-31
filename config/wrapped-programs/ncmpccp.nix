{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    ncmpcppConf =
      pkgs.writeText "conf"
      ''
        lyrics_directory=~/local_music/.lyrics
        mpd_music_dir=~/local_music
      '';
  in {
    packages.ncmpcpp = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.ncmpcpp;
      flags = {
        "-c" = "${ncmpcppConf}";
      };
    };
  };
}
