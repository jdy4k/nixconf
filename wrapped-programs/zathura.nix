{
  inputs,
  lib,
  self,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    zathuraConf =
      pkgs.writeText "zathurarc"
      ''
        set notification-error-bg   "${self.theme.base00}"
        set notification-error-fg   "${self.theme.base08}"
        set notification-warning-bg "${self.theme.base00}"
        set notification-warning-fg "${self.theme.base0A}"
        set notification-bg         "${self.theme.base00}"
        set notification-fg         "${self.theme.base0E}"
      
        set completion-bg           "${self.theme.base01}"
        set completion-fg           "${self.theme.base05}"
        set completion-group-bg     "${self.theme.base00}"
        set completion-group-fg     "${self.theme.base04}"
        set completion-highlight-bg "${self.theme.base0D}"
        set completion-highlight-fg "${self.theme.base00}"
      
        set index-bg                "${self.theme.base00}"
        set index-fg                "${self.theme.base05}"
        set index-active-bg         "${self.theme.base02}"
        set index-active-fg         "${self.theme.base06}"
      
        set inputbar-bg             "${self.theme.base00}"
        set inputbar-fg             "${self.theme.base07}"
      
        set statusbar-bg            "${self.theme.base00}"
        set statusbar-fg            "${self.theme.base06}"
      
        set highlight-color         "rgba(250, 189, 47, 0.45)"
        set highlight-fg            "rgba(250, 189, 47, 0.45)"
        set highlight-active-color  "rgba(254, 128, 25, 0.65)"
      
        set default-bg              "${self.theme.base00}"
        set default-fg              "${self.theme.base06}"
        set render-loading          true
      
        set recolor-lightcolor      "${self.theme.base07}"
        set recolor-darkcolor       "#000000"
        set recolor                 "true"
        set recolor-keephue         "false"
        set page-padding            0
      
        set selection-notification  false
        set selection-clipboard     "primary"
      '';
  in {
    packages.zathura = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.zathura.override { useMupdf = true; };
      flags = {
        "-c" = "${pkgs.runCommand "zathura-config-dir" {} ''
          mkdir -p $out
          cp ${zathuraConf} $out/zathurarc
        ''}";
      };
    };
  };
}
