{ config, ... }: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        highlight.enable = true;
        grammarPackages =
          config.programs.nixvim.plugins.treesitter.package.allGrammars;
      };
    };
  };
}

