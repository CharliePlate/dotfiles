vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

---@class vim.wo
local opt = vim.opt
opt.clipboard = "unnamedplus" -- System Clipboard

opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2

opt.scrolloff = 8 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.wrap = false -- Disable line wrap
opt.undodir = vim.fn.expand("~/.cache/vim/undodir")
opt.undofile = true

opt.pumblend = 0
opt.pumheight = 10
opt.grepformat = "%f:%l:%c:%m"
opt.listchars = "tab:│ ,trail:·,extends:»,precedes:«,nbsp:␣"
opt.numberwidth = 3
opt.relativenumber = true
opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s"
opt.ignorecase = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.conceallevel = 3

opt.swapfile = false

opt.completeopt = { "menuone", "noselect" }

opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.termguicolors = true
opt.autoindent = true

opt.smoothscroll = true

opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current

opt.endofline = false

vim.diagnostic.config({
  float = { border = "rounded" },
})

vim.filetype.add({
  extension = {
    templ = "templ",
  },
})
