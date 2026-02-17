local g = vim.g
g.mapleader = " "
g.maplocalleader = " "
g.have_nerd_font = true

local o = vim.opt

o.clipboard = "unnamedplus" -- System Clipboard

o.expandtab = true -- Use spaces instead of tabs
o.shiftwidth = 2 -- Size of an indent
o.tabstop = 2 -- Number of spaces tabs count for
o.softtabstop = 2

o.scrolloff = 8 -- Lines of context
o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time

o.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

o.wrap = false -- Disable line wrap
o.undodir = vim.fn.expand("~/.cache/vim/undodir")
o.undofile = true

o.pumblend = 0
o.pumheight = 10
o.grepformat = "%f:%l:%c:%m"
o.listchars = "tab:│ ,trail:·,extends:»,precedes:«,nbsp:␣"
o.numberwidth = 3
o.relativenumber = true
o.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s"
o.ignorecase = true
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.conceallevel = 3

o.swapfile = false

o.completeopt = { "menuone", "noselect" }

o.signcolumn = "yes"
o.smartcase = true
o.smartindent = true
o.termguicolors = true
o.autoindent = true

o.smoothscroll = true

o.splitbelow = true -- Put new windows below current
o.splitkeep = "screen"
o.splitright = true -- Put new windows right of current

o.endofline = false
o.winborder = "rounded"
o.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s"

vim.diagnostic.config({
  float = { border = "rounded" },
})

vim.filetype.add({
  extension = {
    templ = "templ",
  },
})
