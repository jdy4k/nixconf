{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    ns =
      pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs; [
          fzf
          nix-search-tv
        ];
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
