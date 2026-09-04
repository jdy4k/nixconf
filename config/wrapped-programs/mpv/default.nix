{
  inputs,
  self,
#  lib,
  ...
}: {
  flake.wrapperModules.mpv = {
 #   config,
 #   lib,
    pkgs,
    ...
  }: let
    configDir = pkgs.runCommand "mpv-config" {} ''
      mkdir -p $out/script-opts
      cp ${./script-opts}/* $out/script-opts/
    '';
  in {
    config = {
      "mpv.conf".content = ''
        ### VIDEO
        
        profile=high-quality
        hwdec=auto-safe
        
        ### SUBTITLES
        
        alang=ja,jp,jpn,japanese,en,eng,english,English,enUS,en-US
        slang=ja,jp,jpn,japanese,en,eng,english,English,enUS,en-US
        
        sub-font="IPAPMincho"
        sub-font-size=40
        
        sub-auto=fuzzy
        subs-with-matching-audio=yes
        
        ### SCREENSHOT
        
        screenshot-directory="~/Pictures/Screenshots/"
        screenshot-template="%F_%wHh%wMm%wSs%wTms"
        screenshot-format=jpg
        screenshot-jpeg-quality=90
        screenshot-high-bit-depth=yes
        
        ### OSD
        
        osd-on-seek=no
        osd-bar=no
        border=no
        osd-back-color="#000000"
        osd-border-style=background-box
        osd-font-size=35
        osd-margin-y=40
      '';
      flags = {
        "--config-dir" = configDir;
      };
    };
  };
  perSystem = {pkgs, ...}: {
    packages.mpv = inputs.wrapper-modules.wrappers.mpv.wrap {
      inherit pkgs;
      imports = [self.wrapperModules.mpv];
      script = {
        autosubsync-mpv.path = pkgs.mpvScripts.autosubsync-mpv;
        mpvacious.path = pkgs.mpvScripts.mpvacious;
        uosc.path = pkgs.mpvScripts.uosc;
      };
    };
  };
}
