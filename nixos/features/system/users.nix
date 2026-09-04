{ ... }: {
  flake.nixosModules.system = { config, ... }: {
    users.users."${config.preferences.user.name}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "gamemode" ];
      initialHashedPassword = "$y$j9T$65Xrap.UjdKYFNZ3RV9Wj/$lhSQnO8PCobbQE3Ok92yzWA2cTmBYwTN/MpnzTrMzB5";
    }; 
  };
}
