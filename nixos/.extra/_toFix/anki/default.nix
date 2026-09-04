{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    japanese = pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
      pname = "Japanese";
      version = "unstable-2025-08-18";
      src = pkgs.fetchFromGitHub {
        owner = "Ajatt-Tools";
        repo = "Japanese";
        rev = "1c993fdb90c771fd5e154bd4e2b57e12a3ca1991";
        hash = "sha256-oQ38Gmvwp1dSgrUZA9pz4DAxPrbQDrhsGoi+BSNh3fs=";
        fetchSubmodules = true;
      };
      sourceRoot = "${finalAttrs.src.name}/japanese";
      patches = [ ./_ajt-japanese.patch ];
      patchFlags = [ "-p2" ];
    });
    ankiWithAddons = pkgs.anki.withAddons [ 
      pkgs.ankiAddons.review-heatmap
      pkgs.ankiAddons.passfail2
      pkgs.ankiAddons.anki-connect
      pkgs.ankiAddons.ajt-card-management
      japanese 
    ];
  in {
    packages.anki = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = ankiWithAddons;
      runtimeInputs = [ pkgs.mecab ];
      env = rec {
        ANKI_JAPANESE_DIR = "$HOME/.local/share/Anki2/";
      };
    };
  };
}
