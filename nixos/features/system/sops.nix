{ ... }: {
  flake.nixosModules.system = { pkgs, config, ... }: {
    environment.systemPackages = with pkgs; [
      sops
      age
    ];
    environment.sessionVariables = {
      SOPS_AGE_KEY_FILE = "/persist/sops/age/keys.txt";
    };
    sops = {
      defaultSopsFile = ../../../.sops.yaml; # Or the correct path to your .sops.yaml
      # Don't mix sshKeyPaths and keyFile
      age.sshKeyPaths = [];
      age.keyFile = "/persist/sops/age/keys.txt";

      secrets = {
        "password_hash" = {
          sopsFile = ../../../secrets/password-hash.yaml; # <-- Points to your password hash file
          owner = "root";
          group = "root";
          mode = "0400";
          neededForUsers = true;
        };
        "cluster_access_key_ed25519" = {
          sopsFile = ../../../secrets/cluster-access-key.yaml;
          key = "cluster_access_key_ed25519";
          owner = "root";
          group = "keys";
          mode = "0440";
        };
        "cluster_host" = {
          sopsFile = ../../../secrets/cluster-access-key.yaml;
          key = "cluster_host";
          owner = "root";
          group = "keys";
          mode = "0440";
        };
        "cluster_user" = {
          sopsFile = ../../../secrets/cluster-access-key.yaml;
          key = "cluster_user";
          owner = "root";
          group = "keys";
          mode = "0440";
        };
        "github_deploy_key_ed25519" = {
          sopsFile = ../../../secrets/github-deploy-key.yaml;
          key = "github_deploy_key_ed25519";
          owner = "root";
          group = "keys";
          mode = "0440";
        };
      };
      templates."ssh_config_cluster".content = ''
        Host jc
            HostName ${config.sops.placeholder.cluster_host}
            User ${config.sops.placeholder.cluster_user}
            IdentityFile ${config.sops.secrets.cluster_access_key_ed25519.path}
            IdentitiesOnly yes
      '';
      templates."ssh_config_cluster".owner = "root";
      templates."ssh_config_cluster".group = "keys";
      templates."ssh_config_cluster".mode = "0440";
    };
    hjem.users.${config.preferences.user.name}.files = {
      ".ssh/cluster_access_key_ed25519.pub".text = "ssh-ed25519 AAAAC3... cluster-access";
      ".ssh/github_deploy_key_ed25519.pub".text = "ssh-ed25519 AAAAC3... github-deploy";
      ".ssh/config".text = ''
Include /run/secrets/rendered/ssh_config_cluster

Host github.com
  HostName github.com
  User git
  IdentityFile /run/secrets/github_deploy_key_ed25519
  IdentitiesOnly yes
      '';
    };
  };
}
