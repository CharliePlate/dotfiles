-- doom-rouge colorscheme for Neovim
-- Ported from the Emacs doom-rouge theme (doomemacs/themes)
-- Original theme by @das-s (VS Code Rouge Theme)

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "doom-rouge"

vim.o.termguicolors = true
vim.o.background = "dark"

local c = {
  bg = "#172030",
  bg_alt = "#101828",
  fg = "#FAFFF6",
  fg_alt = "#A7ACB9",
  base0 = "#070A0E",
  base1 = "#0E131D",
  base2 = "#151D2B",
  base3 = "#1F2A3F",
  base4 = "#5D636E",
  base5 = "#64727d",
  base6 = "#B16E75",
  base7 = "#E8E9EB",
  base8 = "#F0F4FC",
  red = "#D06B67",
  lt_red = "#D4645C",
  orange = "#E8B080",
  yellow = "#F0D896",
  green = "#9DBF8A",
  teal = "#6FBDBD",
  blue = "#6A9FCC",
  dk_blue = "#1E6378",
  cyan = "#7DCCE0",
  dk_cyan = "#507681",
  magenta = "#C08AC0",
  violet = "#5D8CC4",
  salmon = "#CFA08E",
  grey = "#64727d",
  none = "NONE",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.base2 })
hi("FloatBorder", { fg = c.base6, bg = c.base2 })
hi("Cursor", { fg = c.bg, bg = c.fg })
hi("CursorLine", { bg = c.base2 })
hi("CursorLineNr", { fg = c.base7, bold = true })
hi("LineNr", { fg = c.base4 })
hi("SignColumn", { fg = c.base4, bg = c.bg })
hi("ColorColumn", { bg = c.base2 })
hi("Visual", { bg = c.base3 })
hi("VisualNOS", { bg = c.base3 })
hi("Search", { fg = c.fg, bg = c.base4 })
hi("IncSearch", { fg = c.bg, bg = c.orange })
hi("CurSearch", { fg = c.bg, bg = c.orange })
hi("Substitute", { fg = c.bg, bg = c.red })
hi("MatchParen", { fg = c.orange, bg = c.base3, bold = true })
hi("Pmenu", { fg = c.fg_alt, bg = c.base2 })
hi("PmenuSel", { fg = c.fg, bg = c.base3 })
hi("PmenuSbar", { bg = c.base3 })
hi("PmenuThumb", { bg = c.base4 })
hi("WildMenu", { fg = c.fg, bg = c.base3 })
hi("StatusLine", { fg = c.fg, bg = c.base2 })
hi("StatusLineNC", { fg = c.base4, bg = c.base1 })
hi("TabLine", { fg = c.base4, bg = c.base1 })
hi("TabLineFill", { bg = c.base1 })
hi("TabLineSel", { fg = c.fg, bg = c.bg })
hi("WinSeparator", { fg = c.base3 })
hi("VertSplit", { fg = c.base3 })
hi("Folded", { fg = c.violet, bg = c.base2 })
hi("FoldColumn", { fg = c.teal, bg = c.bg })
hi("NonText", { fg = c.base4 })
hi("SpecialKey", { fg = c.base4 })
hi("Conceal", { fg = c.base5 })
hi("Directory", { fg = c.blue })
hi("Title", { fg = c.orange, bold = true })
hi("ErrorMsg", { fg = c.lt_red })
hi("WarningMsg", { fg = c.yellow })
hi("MoreMsg", { fg = c.green })
hi("ModeMsg", { fg = c.fg, bold = true })
hi("Question", { fg = c.green })
hi("SpellBad", { undercurl = true, sp = c.red })
hi("SpellCap", { undercurl = true, sp = c.yellow })
hi("SpellLocal", { undercurl = true, sp = c.blue })
hi("SpellRare", { undercurl = true, sp = c.magenta })
hi("Whitespace", { fg = c.base3 })
hi("EndOfBuffer", { fg = c.bg })
hi("WinBar", { fg = c.fg_alt, bg = c.bg })
hi("WinBarNC", { fg = c.base4, bg = c.bg })

-- Syntax
hi("Comment", { fg = c.violet, italic = true })
hi("Constant", { fg = c.red })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.orange })
hi("Boolean", { fg = c.orange })
hi("Float", { fg = c.orange })
hi("Identifier", { fg = c.red })
hi("Function", { fg = c.salmon })
hi("Statement", { fg = c.magenta })
hi("Conditional", { fg = c.magenta, italic = true })
hi("Repeat", { fg = c.magenta, italic = true })
hi("Label", { fg = c.magenta })
hi("Operator", { fg = c.magenta })
hi("Keyword", { fg = c.magenta, italic = true })
hi("Exception", { fg = c.magenta })
hi("PreProc", { fg = c.magenta, italic = true })
hi("Include", { fg = c.magenta, italic = true })
hi("Define", { fg = c.magenta, italic = true })
hi("Macro", { fg = c.magenta, italic = true })
hi("PreCondit", { fg = c.magenta, italic = true })
hi("Type", { fg = c.red })
hi("StorageClass", { fg = c.magenta })
hi("Structure", { fg = c.red })
hi("Typedef", { fg = c.red })
hi("Special", { fg = c.salmon })
hi("SpecialChar", { fg = c.salmon })
hi("Tag", { fg = c.salmon })
hi("Delimiter", { fg = c.fg_alt })
hi("SpecialComment", { fg = c.violet, italic = true })
hi("Debug", { fg = c.lt_red })
hi("Underlined", { underline = true })
hi("Error", { fg = c.lt_red })
hi("Todo", { fg = c.yellow, bg = c.base3, bold = true })

-- Treesitter
hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.lt_red })
hi("@variable.parameter", { fg = c.red })
hi("@variable.member", { fg = c.red })
hi("@constant", { fg = c.red })
hi("@constant.builtin", { fg = c.orange })
hi("@constant.macro", { fg = c.orange })
hi("@module", { fg = c.red })
hi("@string", { fg = c.green })
hi("@string.regex", { fg = c.teal })
hi("@string.escape", { fg = c.teal })
hi("@character", { fg = c.green })
hi("@number", { fg = c.orange })
hi("@boolean", { fg = c.orange })
hi("@float", { fg = c.orange })
hi("@function", { fg = c.salmon })
hi("@function.builtin", { fg = c.lt_red })
hi("@function.macro", { fg = c.salmon })
hi("@function.method", { fg = c.salmon })
hi("@function.method.call", { fg = c.salmon })
hi("@constructor", { fg = c.salmon })
hi("@keyword", { fg = c.magenta, italic = true })
hi("@keyword.function", { fg = c.magenta, italic = true })
hi("@keyword.return", { fg = c.magenta, italic = true })
hi("@keyword.operator", { fg = c.magenta })
hi("@keyword.conditional", { fg = c.magenta, italic = true })
hi("@keyword.repeat", { fg = c.magenta, italic = true })
hi("@keyword.import", { fg = c.magenta, italic = true })
hi("@keyword.exception", { fg = c.magenta })
hi("@operator", { fg = c.magenta })
hi("@punctuation.bracket", { fg = c.fg_alt })
hi("@punctuation.delimiter", { fg = c.fg_alt })
hi("@punctuation.special", { fg = c.salmon })
hi("@type", { fg = c.red })
hi("@type.builtin", { fg = c.red })
hi("@type.qualifier", { fg = c.magenta, italic = true })
hi("@tag", { fg = c.red })
hi("@tag.attribute", { fg = c.salmon })
hi("@tag.delimiter", { fg = c.fg_alt })
hi("@property", { fg = c.red })
hi("@attribute", { fg = c.magenta })
hi("@comment", { fg = c.violet, italic = true })
hi("@markup.heading", { fg = c.red, bold = true })
hi("@markup.italic", { italic = true })
hi("@markup.strong", { bold = true })
hi("@markup.link", { fg = c.salmon, underline = true })
hi("@markup.link.url", { fg = c.blue, underline = true })
hi("@markup.raw", { fg = c.green })
hi("@markup.list", { fg = c.magenta })

-- LSP semantic tokens
hi("@lsp.type.class", { fg = c.red })
hi("@lsp.type.decorator", { fg = c.salmon })
hi("@lsp.type.enum", { fg = c.red })
hi("@lsp.type.enumMember", { fg = c.orange })
hi("@lsp.type.function", { fg = c.salmon })
hi("@lsp.type.interface", { fg = c.red })
hi("@lsp.type.macro", { fg = c.salmon })
hi("@lsp.type.method", { fg = c.salmon })
hi("@lsp.type.namespace", { fg = c.red })
hi("@lsp.type.parameter", { fg = c.red })
hi("@lsp.type.property", { fg = c.red })
hi("@lsp.type.struct", { fg = c.red })
hi("@lsp.type.type", { fg = c.red })
hi("@lsp.type.typeParameter", { fg = c.red })
hi("@lsp.type.variable", { fg = c.fg })

-- Diagnostics
hi("DiagnosticError", { fg = c.lt_red })
hi("DiagnosticWarn", { fg = c.yellow })
hi("DiagnosticInfo", { fg = c.blue })
hi("DiagnosticHint", { fg = c.teal })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.lt_red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.teal })
hi("DiagnosticVirtualTextError", { fg = c.lt_red, bg = c.base2 })
hi("DiagnosticVirtualTextWarn", { fg = c.yellow, bg = c.base2 })
hi("DiagnosticVirtualTextInfo", { fg = c.blue, bg = c.base2 })
hi("DiagnosticVirtualTextHint", { fg = c.teal, bg = c.base2 })

-- Diff
hi("DiffAdd", { bg = "#1a2e1a" })
hi("DiffChange", { bg = "#1a1e2e" })
hi("DiffDelete", { fg = c.red, bg = "#2e1a1a" })
hi("DiffText", { bg = "#2a2e3e" })
hi("diffAdded", { fg = c.green })
hi("diffRemoved", { fg = c.red })
hi("diffChanged", { fg = c.blue })

-- Git signs
hi("GitSignsAdd", { fg = c.green })
hi("GitSignsChange", { fg = c.blue })
hi("GitSignsDelete", { fg = c.red })
hi("GitSignsAddNr", { fg = c.green })
hi("GitSignsChangeNr", { fg = c.blue })
hi("GitSignsDeleteNr", { fg = c.red })

-- Telescope
hi("TelescopeNormal", { fg = c.fg_alt, bg = c.base1 })
hi("TelescopeBorder", { fg = c.base4, bg = c.base1 })
hi("TelescopePromptNormal", { fg = c.fg, bg = c.base2 })
hi("TelescopePromptBorder", { fg = c.base4, bg = c.base2 })
hi("TelescopePromptTitle", { fg = c.bg, bg = c.orange })
hi("TelescopePreviewTitle", { fg = c.bg, bg = c.green })
hi("TelescopeResultsTitle", { fg = c.bg, bg = c.blue })
hi("TelescopeSelection", { fg = c.fg, bg = c.base3 })
hi("TelescopeMatching", { fg = c.orange, bold = true })

-- Snacks picker (uses Telescope highlights but also has its own)
hi("SnacksPickerMatch", { fg = c.orange, bold = true })

-- Indent blankline
hi("IblIndent", { fg = c.base3 })
hi("IblScope", { fg = c.base4 })

-- Which-key
hi("WhichKey", { fg = c.orange })
hi("WhichKeyGroup", { fg = c.magenta })
hi("WhichKeyDesc", { fg = c.fg_alt })
hi("WhichKeyBorder", { fg = c.base4, bg = c.base1 })
hi("WhichKeyFloat", { bg = c.base1 })
hi("WhichKeySeparator", { fg = c.base4 })

-- Neo-tree
hi("NeoTreeRootName", { fg = c.orange, bold = true })
hi("NeoTreeDirectoryName", { fg = c.blue })
hi("NeoTreeDirectoryIcon", { fg = c.blue })
hi("NeoTreeFileName", { fg = c.fg_alt })
hi("NeoTreeGitAdded", { fg = c.green })
hi("NeoTreeGitConflict", { fg = c.lt_red })
hi("NeoTreeGitDeleted", { fg = c.red })
hi("NeoTreeGitModified", { fg = c.orange })
hi("NeoTreeGitUntracked", { fg = c.grey })
hi("NeoTreeNormal", { fg = c.fg_alt, bg = c.bg_alt })
hi("NeoTreeNormalNC", { fg = c.fg_alt, bg = c.bg_alt })

-- Dashboard
hi("DashboardHeader", { fg = c.red })
hi("DashboardCenter", { fg = c.magenta })
hi("DashboardShortCut", { fg = c.teal })
hi("DashboardFooter", { fg = c.violet, italic = true })

-- Noice / Notify
hi("NoiceCmdlinePopup", { fg = c.fg, bg = c.base2 })
hi("NoiceCmdlinePopupBorder", { fg = c.base4, bg = c.base2 })
hi("NotifyERRORBorder", { fg = c.lt_red })
hi("NotifyERRORIcon", { fg = c.lt_red })
hi("NotifyERRORTitle", { fg = c.lt_red })
hi("NotifyWARNBorder", { fg = c.yellow })
hi("NotifyWARNIcon", { fg = c.yellow })
hi("NotifyWARNTitle", { fg = c.yellow })
hi("NotifyINFOBorder", { fg = c.blue })
hi("NotifyINFOIcon", { fg = c.blue })
hi("NotifyINFOTitle", { fg = c.blue })

-- Illuminate
hi("IlluminatedWordText", { bg = c.base3 })
hi("IlluminatedWordRead", { bg = c.base3 })
hi("IlluminatedWordWrite", { bg = c.base3 })

-- Lazy
hi("LazyH1", { fg = c.bg, bg = c.blue, bold = true })
hi("LazyButton", { fg = c.fg_alt, bg = c.base3 })
hi("LazyButtonActive", { fg = c.bg, bg = c.blue })
hi("LazySpecial", { fg = c.orange })

-- Mini
hi("MiniIndentscopeSymbol", { fg = c.base4 })
hi("MiniStatuslineFilename", { fg = c.fg_alt, bg = c.base2 })

-- Flash
hi("FlashLabel", { fg = c.bg, bg = c.orange, bold = true })
hi("FlashMatch", { fg = c.fg, bg = c.base3 })
hi("FlashCurrent", { fg = c.fg, bg = c.base4 })

-- Todo comments
hi("TodoBgFIX", { fg = c.bg, bg = c.lt_red, bold = true })
hi("TodoBgTODO", { fg = c.bg, bg = c.blue, bold = true })
hi("TodoBgHACK", { fg = c.bg, bg = c.yellow, bold = true })
hi("TodoBgWARN", { fg = c.bg, bg = c.yellow, bold = true })
hi("TodoBgNOTE", { fg = c.bg, bg = c.teal, bold = true })
hi("TodoBgPERF", { fg = c.bg, bg = c.magenta, bold = true })
hi("TodoFgFIX", { fg = c.lt_red })
hi("TodoFgTODO", { fg = c.blue })
hi("TodoFgHACK", { fg = c.yellow })
hi("TodoFgWARN", { fg = c.yellow })
hi("TodoFgNOTE", { fg = c.teal })
hi("TodoFgPERF", { fg = c.magenta })
