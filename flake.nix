{
  inputs = {
    # https://determinate.systems/blog/nixpkgs-cooldown/
    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";

    # BTRFS + LUKS + impermanence (root-blank)  
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    
    # Dendric pattern
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Wrapper/hjem for program configurations
    wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";    
    hjem.url = "github:feel-co/hjem";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./config);
  # Import all .nix files from current directory except flake.nix recursively
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    inherit (lib.fileset) toList fileFilter;

    isNixModule = file:
      file.hasExt "nix"
      && file.name != "flake.nix"
      && !lib.hasPrefix "_" file.name;

    importTree = path:
      toList (fileFilter isNixModule path);

    mkFlake = inputs.flake-parts.lib.mkFlake {inherit inputs;};
  in
    mkFlake {imports = importTree ./.;};
}
