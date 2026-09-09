{ inputs, ... }: {
  perSystem = {
    pkgs,
    ...
  }: let
  japanese = pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
    pname = "Japanese";
    version = "v26.1.13.0";
    src = (pkgs.fetchFromGitHub {
      owner = "Ajatt-Tools";
      repo = "Japanese";
      rev = "6d048c9d8441fd8ce9223903cc7253c8e987b674";
      hash = "sha256-hm/BCM7A1TRPAMLJnWhHkaAXxpKhZc+P3NqHJzYJrxs=";
      fetchSubmodules = true;
      preFetch = ''
        export GIT_CONFIG_COUNT=1
        export GIT_CONFIG_KEY_0=url.https://github.com/.insteadOf
        export GIT_CONFIG_VALUE_0=git@github.com:
      '';
    });
    sourceRoot = "${finalAttrs.src.name}/japanese";
    postFixup = ''
      # cp -r ${finalAttrs.src}/kanjigrid $out/share/anki/addons/Japanese
      mkdir -p $out/share/anki/addons/Japanese/kanjigrid/
      cp ${finalAttrs.src}/kanjigrid/src/* $out/share/anki/addons/Japanese/kanjigrid/
      cp ${finalAttrs.src}/kanjigrid/*.* $out/share/anki/addons/Japanese/kanjigrid/
      cp -r ${finalAttrs.src}/kanjigrid/tools $out/share/anki/addons/Japanese/kanjigrid/
      cp -r ${finalAttrs.src}/kanjigrid/src $out/share/anki/addons/Japanese/kanjigrid/
      cp -r ${finalAttrs.src}/kanjigrid/data $out/share/anki/addons/Japanese/kanjigrid/
      cp -r ${finalAttrs.src}/kanjigrid/docs $out/share/anki/addons/Japanese/kanjigrid/
      cp -r ${finalAttrs.src}/kanjigrid/tests $out/share/anki/addons/Japanese/kanjigrid/
    '';
    patches = [ ./japanese.patch ];
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
      env = {
        ANKI_JAPANESE_DIR = "$HOME/.local/share/Anki2/";
      };
    };
  };
}
