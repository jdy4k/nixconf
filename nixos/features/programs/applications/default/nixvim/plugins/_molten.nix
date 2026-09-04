{ lib, pkgs, ...} : let
  pyEnv = pkgs.python3.withPackages 
    (p: with p; [
      pandas
      requests
      pynvim
      jupyter-client
      cairosvg
      ipython
      nbformat
      ipykernel
      matplotlib
      pandas
      numpy
    ]);

  rPackages = with pkgs.rPackages; [
    tidyverse
    mosaicData
    IRkernel
    tinytex
  ];

  rEnv = pkgs.rWrapper.override { 
    packages = rPackages;
  };

  rKernel_json = pkgs.writeText "kernel.json"
    ''
    {
    "argv": ["${rEnv}/bin/R", "--slave", "-e", "IRkernel::main()", "--args", "{connection_file}"],
    "display_name": "R",
    "language": "R"
    }
    '';
  pyKernel_json = pkgs.writeText "kernel.json"
    ''
    {
    "argv": ["${pyEnv}/bin/python", "-m", "ipykernel_launcher", "-f", "{connection_file}"],
    "display_name": "Python 3 (ipykernel)",
    "language": "python",
    "metadata": {
      "debugger": true
      }
    }
    '';

  jupyterKernels = pkgs.runCommand "json-gen" { }
    ''
    mkdir -p $out/kernels/iPython
    mkdir -p $out/kernels/iR
    cp ${pyKernel_json} $out/kernels/iPython/kernel.json
    cp ${rKernel_json} $out/kernels/iR/kernel.json
    '';

    # Quarto 1.10 passes pandoc --syntax-highlighting; nixpkgs pandoc 3.7 only
    # accepts --highlight-style (https://github.com/NixOS/nixpkgs/issues/519484).
    quarto = (pkgs.quarto.override {
      extraRPackages = rPackages;
    }).overrideAttrs (old: {
      postFixup = (old.postFixup or "") + ''
        substituteInPlace $out/bin/quarto.js \
          --replace-fail 'kSyntaxHighlighting = "syntax-highlighting"' 'kSyntaxHighlighting = "highlight-style"' \
          --replace-fail '"--syntax-highlighting"' '"--highlight-style"'
      '';
    });
in
{
  programs.nixvim = {
    nixpkgs.config.allowUnfreePredicate = 
      pkg: builtins.elem (lib.getName pkg) [
        "wezterm.nvim"
        "jupytext.nvim"
      ];
      keymaps = [
        { mode = "n"; 
          key = "<localleader>e"; 
          action = "<cmd>MoltenEvaluateOperator<CR>"; 
          options = { silent = true; desc = "evaluate operator"; }; 
        }
        { mode = "n"; 
          key = "<localleader>os"; 
          action = "<cmd>noautocmd MoltenEnterOutput<CR>"; 
          options = { silent = true; desc = "open output window"; }; 
        }
        { mode = "n"; 
          key = "<localleader>rr"; 
          action = "<cmd>MoltenReevaluateCell<CR>"; 
          options = { silent = true; desc = "re-eval cell"; }; 
        }
        { mode = "n"; key = "<localleader>oh"; 
          action = "<cmd>MoltenHideOutput<CR>"; 
          options = { silent = true; desc = "close output window"; }; 
        }
        { mode = "n"; 
          key = "<localleader>md"; 
          action = "<cmd>MoltenDelete<CR>"; 
          options = { silent = true; desc = "delete Molten cell"; }; 
        }
        { mode = "n"; 
          key = "<localleader>rc"; 
          action.__raw = "function() require('quarto.runner').run_cell() end"; 
          options = { silent = true; desc = "run cell"; }; 
        }
        { mode = "n"; 
          key = "<localleader>ra"; 
          action.__raw = "function() require('quarto.runner').run_above() end"; 
          options = { silent = true; desc = "run cell and above"; }; 
        }
        { mode = "n"; 
          key = "<localleader>rA"; 
          action.__raw = "function() require('quarto.runner').run_all() end"; 
          options = { silent = true; desc = "run all cells"; };
        }
        { mode = "n"; 
          key = "<localleader>rl"; 
          action.__raw = "function() require('quarto.runner').run_line() end"; 
          options = { silent = true; desc = "run line"; }; 
        }
        { mode = "v"; 
          key = "<localleader>r"; 
          action.__raw = "function() require('quarto.runner').run_range() end"; 
          options = { silent = true; desc = "run visual range"; }; 
        }
        { mode = "n"; 
          key = "<localleader>RA"; 
          action.__raw = "function() require('quarto.runner').run_all(true) end"; 
          options = { silent = true; desc = "run all cells of all languages"; }; 
        }
        { 
          mode = "n"; 
          key = "<leader>mx"; 
          action = ":w<CR>:!quarto render % --to html && xdg-open %:r.html<CR>"; 
          options = { silent = true; desc = "Render and open HTML"; }; 
        }
      ];

    extraPackages = [
      quarto
    ];

    extraConfigLuaPre = ''
      vim.env.JUPYTER_PATH = "${jupyterKernels}"
    '';

    files."ftplugin/markdown.lua".extraConfigLua = ''
        require("quarto").activate()
      '';

    plugins = {
      otter = {
        enable = true;
        autoActivate = false;
      };
      quarto = {
        enable = true;
        settings = {
          lspFeatures = {
            languages = ["r" "python" "rust"];
            chunks = "all";
            diagnostics = {
              enabled = true;
              triggers = ["BufWritePost"];
            };
            completion.enabled = true;
          };
          keymap = {
            hover = "H";
            definition = "gd";
            rename = "<leader>rn";
            references = "gr";
            format = "<leader>gf";
          };
          codeRunner = {
            enabled = true;
            default_method = "molten";
          };
        };
      };
      jupytext = {
        enable = true;
        settings = {
          style = "markdown";
          output_extension = "md";
          force_ft = "markdown";
        };
      };
      molten = {
        enable = true;
        settings = {
          auto_image_popup = false;
          auto_init_behavior = "init";
          auto_open_html_in_browser = false;
          cover_empty_lines = false;
          copy_output = false;
          enter_output_behavior = "open_then_enter";
          output_crop_border = true;
          output_virt_lines = false;
          output_win_hide_on_leave = true;
          output_win_max_height = 15;
          output_win_max_width = 80;
          tick_rate = 500;
          use_border_highlights = false;
          limit_output_chars = 10000;
          auto_open_output = false;
          image_provider = "image.nvim";
          wrap_output = true;
          virt_text_output = true;
          virt_lines_off_by_1 = true;
          output_win_border = ["" "━" "" ""];
          save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
        };
      };
    };
  };
}

