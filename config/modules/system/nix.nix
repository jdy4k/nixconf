{self, ...}: {
  flake.nixosModules.system = {pkgs, ...}: let
    selfpkgs = self.packages."${pkgs.system}";
  in  {
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = ["https://cache.nixos.org"];
      trusted-substituters = ["https://cache.nixos.org"];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
    programs.nix-ld.enable = true;

    environment.systemPackages = [
      pkgs.nil
      pkgs.nixd
      pkgs.statix
      pkgs.alejandra
      pkgs.manix
      pkgs.nix-inspect
      pkgs.nix-search-tv
      pkgs.fzf

      selfpkgs.nh
      selfpkgs.ns
    ];
  };
}
