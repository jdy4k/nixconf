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
    alacrittyConf =
      pkgs.writeText "alacritty.toml"
      ''
      [font]
      size = 16.0

      [font.normal]
      family = "FiraCode Nerd Font"

      [window.padding]
      x = 12
      y = 12

      [colors.primary]
      background = "0x282828"
      foreground = "0xebdbb2"

      [colors.normal]
      black = "0x282828"
      red = "0xcc241d"
      green = "0x98971a"
      yellow = "0xd79921"
      blue = "0x458588"
      magenta = "0xb16286"
      cyan = "0x689d6a"
      white = "0xa89984"

      [colors.bright]
      black = "0x928374"
      red = "0xfb4934"
      green = "0xb8bb26"
      yellow = "0xfabd2f"
      blue = "0x83a598"
      magenta = "0xd3869b"
      cyan = "0x8ec07c"
      white = "0xebdbb2"
      ''
      ;
  in {
    packages.alacritty = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.alacritty;
      flags = {
        "--config-file" = "${alacrittyConf}";
        "-e" = "fish";
      };
    };
  };
}
