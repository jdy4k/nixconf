-- Gruvbox dark medium, matching the foot terminal palette exactly
-- (see modules/wrapped-programs/foot.nix).
local COLORSCHEME = {
    base00 = "#282828", -- foot background
    base01 = "#3c3836",
    base02 = "#504945",
    base03 = "#665c54",
    base04 = "#bdae93",
    base05 = "#d5c4a1",
    base06 = "#ebdbb2", -- foot foreground
    base07 = "#fbf1c7",
    base08 = "#fb4934", -- foot bright1
    base09 = "#fe8019",
    base0A = "#fabd2f", -- foot bright3
    base0B = "#b8bb26", -- foot bright2
    base0C = "#8ec07c", -- foot bright6
    base0D = "#83a598", -- foot bright4
    base0E = "#d3869b", -- foot bright5
    base0F = "#d65d0e",

    green = "#b8bb26",
    cyan = "#8ec07c",
    blue2 = "#458588", -- foot regular4

    bg = "#282828",
    fg = "#ebdbb2",
    orange = "#fe8019",
    red = "#fb4934",
    blue = "#83a598",
    yellow = "#fabd2f",
    magenta = "#d3869b",
    gray = "#32302f",      -- gruvbox bg0_soft (cursorline)
    lightgray = "#3c3836", -- gruvbox bg1 (statusline sections)
    darkgray = "#1d2021",  -- gruvbox bg0_hard
    inactivegray = "#1d2021",

    -- The 16 ANSI colors as configured in foot (regular0-7, bright0-7)
    term = {
        [0] = "#282828",
        [1] = "#cc241d",
        [2] = "#98971a",
        [3] = "#d79921",
        [4] = "#458588",
        [5] = "#b16286",
        [6] = "#689d6a",
        [7] = "#a89984",
        [8] = "#928374",
        [9] = "#fb4934",
        [10] = "#b8bb26",
        [11] = "#fabd2f",
        [12] = "#83a598",
        [13] = "#d3869b",
        [14] = "#8ec07c",
        [15] = "#ebdbb2",
    },
}

return COLORSCHEME
