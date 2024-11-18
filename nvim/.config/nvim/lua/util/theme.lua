-- rouge.lua
local M = {}

local palette = {
  bg = "#172030",
  bg_alt = "#101828",
  base0 = "#070A0E",
  base1 = "#0E131D",
  base2 = "#151D2B",
  base3 = "#1F2A3F",
  base4 = "#5D636E",
  base5 = "#64727d",
  base6 = "#B16E75",
  base7 = "#E8E9EB",
  base8 = "#F0F4FC",
  fg = "#FFFFFF",
  fg_alt = "#C0C5D2",
  grey = "#8E99A8",
  red = "#FF7A7A",
  light_red = "#FF85A6",
  orange = "#FFD4B0",
  green = "#C1D1B7",
  teal = "#98C5C5",
  yellow = "#FFF3CF",
  blue = "#88B2DB",
  dark_blue = "#2A7A94",
  magenta = "#D1A6D1",
  salmon = "#FFD5CC",
  violet = "#7499CC",
  cyan = "#A2DAEA",
  dark_cyan = "#689AAB",
  purple = "#B794E3",
  azure = "#007FFF",

  file_azure = "#00B7FF", -- Brighter, more vibrant azure
  file_blue = "#4B9EFF", -- More electric blue
  file_cyan = "#50E3C2", -- Mint cyan
  file_green = "#96E072", -- Lime green
  file_grey = "#8493A8", -- Slate grey
  file_orange = "#FF9D5C", -- Bright orange
  file_purple = "#CF8DFF", -- Bright purple
  file_red = "#FF6B6B", -- Coral red
  file_yellow = "#FFD76D", -- Golden yellow
}

function M.setup()
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "rouge"

  local groups = {
    -- Base
    Normal = { fg = palette.fg, bg = palette.bg },
    NormalFloat = { fg = palette.fg, bg = palette.bg_alt },
    Comment = { fg = palette.grey, italic = true },
    Constant = { fg = palette.red },
    String = { fg = palette.green },
    Character = { fg = palette.green },
    Number = { fg = palette.orange },
    Boolean = { fg = palette.orange },
    Float = { fg = palette.orange },
    Identifier = { fg = palette.red },
    Function = { fg = palette.salmon },
    Statement = { fg = palette.magenta, italic = true },
    Conditional = { fg = palette.magenta, italic = true },
    Repeat = { fg = palette.magenta, italic = true },
    Label = { fg = palette.magenta },
    Operator = { fg = palette.magenta },
    Keyword = { fg = palette.magenta, italic = true },
    Exception = { fg = palette.magenta },
    PreProc = { fg = palette.magenta },
    Include = { fg = palette.magenta },
    Define = { fg = palette.magenta },
    Title = { fg = palette.red },
    Type = { fg = palette.red },
    StorageClass = { fg = palette.orange },
    Structure = { fg = palette.magenta },
    Special = { fg = palette.blue },
    SpecialComment = { fg = palette.grey },
    Error = { fg = palette.red },
    Todo = { fg = palette.yellow, bold = true },

    -- Treesitter
    ["@function"] = { fg = palette.salmon },
    ["@method"] = { fg = palette.light_red },
    ["@function.builtin"] = { fg = palette.light_red },
    ["@property"] = { fg = palette.red },
    ["@field"] = { fg = palette.red },
    ["@parameter"] = { fg = palette.red },
    ["@variable"] = { fg = palette.red },
    ["@variable.builtin"] = { fg = palette.light_red },
    ["@keyword"] = { fg = palette.magenta, italic = true },
    ["@keyword.operator"] = { fg = palette.magenta },
    ["@constant"] = { fg = palette.red },
    ["@constant.builtin"] = { fg = palette.orange },
    ["@string"] = { fg = palette.green },
    ["@comment"] = { fg = palette.grey, italic = true },
    ["@type"] = { fg = palette.red },
    ["@type.builtin"] = { fg = palette.red },

    -- Editor
    Cursor = { fg = palette.bg, bg = palette.fg },
    CursorLine = { bg = palette.base2 },
    CursorColumn = { bg = palette.base2 },
    ColorColumn = { bg = palette.base2 },
    LineNr = { fg = palette.base5 },
    CursorLineNr = { fg = palette.base7 },
    VertSplit = { fg = palette.base6 },
    StatusLine = { fg = palette.fg, bg = palette.base1 },
    StatusLineNC = { fg = palette.base6, bg = palette.base1 },
    Search = { fg = palette.bg, bg = palette.blue },
    IncSearch = { fg = palette.bg, bg = palette.blue },
    Visual = { bg = palette.base4 },

    -- PMenu
    Pmenu = { fg = palette.fg, bg = palette.bg_alt },
    PmenuSel = { fg = palette.base0, bg = palette.blue },
    PmenuSelBold = { fg = palette.base0, bg = palette.blue },
    PmenuSbar = { bg = palette.base4 },
    PmenuThumb = { bg = palette.blue },

    -- Git
    DiffAdd = { fg = palette.green },
    DiffChange = { fg = palette.orange },
    DiffDelete = { fg = palette.red },
    DiffText = { fg = palette.blue },

    -- Mini Icons
    MiniIconsAzure = { fg = palette.file_azure },
    MiniIconsBlue = { fg = palette.file_blue },
    MiniIconsCyan = { fg = palette.file_cyan },
    MiniIconsGreen = { fg = palette.file_green },
    MiniIconsGrey = { fg = palette.file_grey },
    MiniIconsOrange = { fg = palette.file_orange },
    MiniIconsPurple = { fg = palette.file_purple },
    MiniIconsRed = { fg = palette.file_red },
    MiniIconsYellow = { fg = palette.file_yellow },
  }

  -- Set highlight groups
  for group, settings in pairs(groups) do
    vim.api.nvim_set_hl(0, group, settings)
  end
end

return M
