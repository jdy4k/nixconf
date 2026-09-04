{ inputs, ... }: {
  flake.nixosModules.applications = { ... }: {
    imports = [ 
      ./plugins/_lsp.nix
      ./plugins/_image.nix
      ./plugins/_telescope.nix
      ./plugins/_lualine.nix
      ./plugins/_molten.nix
      ./plugins/_blink-cmp.nix
      ./plugins/_treesitter.nix
    ];

    programs.nixvim = {
      enable = true;
      viAlias = true;
      nixpkgs.source = inputs.nixpkgs;

      extraFiles = {
        "/lua/colorscheme.lua".source = ./extraFiles/lua/colorscheme.lua;
        "/colors/gxvjbox.lua".source = ./extraFiles/colors/gxvjbox.lua;
      };
      colorscheme = "gxvjbox";

      globals.mapleader = " ";
      opts = {
        tabstop = 2;
        shiftwidth = 2;
        expandtab = true;
        laststatus = 3;
        relativenumber = true;
        wrap = true;
        linebreak = true;
        clipboard = "unnamedplus";
        termguicolors = true;
        splitbelow = true;
        splitright = true;
        scrolloff = 9;
        cursorline = true;
        signcolumn = "yes";
        pumheight = 16;
        winborder = "single";
        wildmenu = true;
        wildmode = "longest:full,full";
      };

      plugins = {
        web-devicons.enable = true;
        nvim-autopairs.enable = true;
        snacks.enable = true;
        smear-cursor.enable = true;
        cmp.enable = true;
      };
    };
  };
}
