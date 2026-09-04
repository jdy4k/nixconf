{ self, ... }: {
  flake.nixosModules.gimp = { pkgs, ...}: let
    selfpkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    # GIMP 3 is GTK3/Wayland-capable. Forcing Wayland avoids xwayland-satellite,
    # which niri respawns on every X11 connect and which has been SIGTERM'd in
    # lockstep with compositor session teardowns.
    # gimpWayland = pkgs.symlinkJoin {
    #   name = "gimp";
    #   paths = [ pkgs.gimp ];
    #   nativeBuildInputs = [ pkgs.makeWrapper ];
    #   postBuild = ''
    #     for b in "$out"/bin/gimp "$out"/bin/gimp-3 "$out"/bin/gimp-3.2; do
    #       if [ -L "$b" ]; then
    #         rm "$b"
    #         makeWrapper ${pkgs.gimp}/bin/$(basename "$b") "$b" \
    #           --set GDK_BACKEND wayland
    #       fi
    #     done
    #   '';
    # };
  in
  {
    environment.systemPackages = [ pkgs.gimp ];
    
    # Fonts for mtg proxies
    fonts.packages = [
      selfpkgs.mtg-fonts
      selfpkgs.mtg-symbols
    ];
  };
}
