# CLI tools, installed globally.
{ self, ... }: {
  flake.nixosModules.cli = { pkgs, ... }: let
    selfpkgs = self.packages.${pkgs.system};
  in {
    environment.systemPackages = (with pkgs; [
      # Nix tooling
      nil
      nixd
      statix
      alejandra
      manix
      nix-inspect

      # General utilities
      file
      unzip
      zip
      atool
      p7zip
      wget
      killall
      sshfs
      fzf
      htop
      btop
      eza
      fd
      zoxide
      dust
      ripgrep
      tree
      tree-sitter
      imagemagick
      ffmpeg-full
      wl-clipboard
      yazi

      sbctl
    ]) ++ [
      # Wrapped packages from this flake
      selfpkgs.git
      selfpkgs.neovimDynamic
    ];
  };
}
