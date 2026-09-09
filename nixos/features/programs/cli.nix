{
  flake.nixosModules.cli = { pkgs, config, ... }: {
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
      git
      sbctl
    ]);
    hjem.users.${config.preferences.user.name} = {
      directory = "/home/${config.preferences.user.name}";
      files.".gitconfig" = {
        text =
        ''
        [user]
	        email = ${config.preferences.user.email}
	        name = ${config.preferences.user.name}
        '';
        clobber = true;
      };
    };
  };
}
