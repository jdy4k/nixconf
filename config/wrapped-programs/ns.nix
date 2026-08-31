{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    ns =
      pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
        # Don't builtins.readFile the src path: that is import-from-derivation
        # and forces a stdenv bootstrap during flake eval. Interpolating the
        # path keeps it as a normal build-time dependency instead.
        text = ''
          exec bash ${pkgs.nix-search-tv.src}/nixpkgs.sh "$@"
        '';
      };
  in {
    packages.ns = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = ns;
    };
  };
}
