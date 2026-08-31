{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    ...
  }: let
    fishConf =
      pkgs.writeText "fishy-fishy"
      ''
        set -g fish_color_autosuggestion 908caa
        set -g fish_pager_color_description 908caa
        set -gx LS_COLORS (${lib.getExe pkgs.vivid} generate gruvbox-dark)

        set fish_greeting
        ${lib.getExe pkgs.zoxide} init fish | source

        function prompt_newline --on-event fish_postexec
            echo
        end

        alias clear "command clear; commandline -f clear-screen"
        alias lf "yazi"
      '';
  in {
    packages.fish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      runtimeInputs = [
        pkgs.zoxide
        pkgs.vivid
        pkgs.fzf
      ];
      flags = {
        "-C" = "source ${fishConf}";
      };
    };
  };
}
