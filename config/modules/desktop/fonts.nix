{ ... }: {
  flake.nixosModules.desktop = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts-cjk-sans
      ipafont
      vollkorn
      ubuntu-sans
      cm_unicode
      unifont
    ];

    fonts.fontconfig.defaultFonts = {
      serif = [ "Ubuntu Sans" ];
      sansSerif = [ "Ubuntu Sans" ];
      monospace = [ "FiraCode Nerd Font" ];
    };
  };
}
