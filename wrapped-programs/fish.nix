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

        function nix
          if test "$argv[1]" = "develop"
            set -gx IN_NIX_DEVELOP 1
            command nix develop -c fish $argv[2..-1]
            set -e IN_NIX_DEVELOP
          else
            command nix $argv
          end
        end

        function fish_prompt
          # Login info if applicable
          if functions -q prompt_login
            echo -n -s (prompt_login)' '
          end

          set_color 98971a

          # If exactly at $HOME, render ~ and > right next to each other
          if test "$PWD" = "$HOME"
            echo -n "~"
            set_color normal
            echo -n ">"
            set_color normal
            echo -n " "
            return
          end

          # In other directories, print path, then allow elements to appear before the >
          echo -n (prompt_pwd)
          set_color normal

          if test -n "$IN_NIX_SHELL"
            set_color yellow
            echo -n " ns"
            set_color normal
          end

          if test -n "$IN_NIX_DEVELOP"
            set_color 98971a
            echo -n " nd"
            set_color normal
          end

          # Git / VCS prompt
          if functions -q fish_vcs_prompt
            fish_vcs_prompt
            echo -n " "
          end

          set_color normal
          echo -n ">"
          set_color normal
          echo -n " "
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
