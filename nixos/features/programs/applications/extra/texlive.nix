{ self, ... }: {
  flake.nixosModules.texlive = { pkgs, config, ...}: {
    environment.systemPackages = [ 
      pkgs.texliveMedium 
      pkgs.texstudio
    ];
  };
}
