{ pkgs, ... }: {
  programs.nixvim = {
    extraPackages = [
      pkgs.alejandra
    ];

    plugins = {
      lsp = {
        enable = true;
        servers = {
          pyright = {
            enable = true;
            settings.python.analysis.diagnosticSeverityOverrides.reportUnusedExpression = "none";
          };
          lua_ls.enable = true;
          ts_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true; # already provided via extraPackages
            installRustc = true;
          };
          nixd.enable = true;
          typos_lsp.enable = true;
          ltex = {
            enable = true;
            filetypes = [ "quarto" ];
            settings = {
              language = "en-US";
              disabledRules.en-US = [ "WHITESPACE_RULE" ];
            };
          };
        };
      };

      lsp-lines.enable = false;
    };
  };
}
