return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_in_macro = false,
    },
    config = function(_, opts)
      local Cond = require("nvim-autopairs.conds")
      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")

      npairs.setup(opts)

      npairs.add_rule(Rule(">[%w%s]*$", "^%s*</", {
        "templ",
      }):only_cr():use_regex(true))

      npairs.add_rule(Rule("<!--", "-->", "templ"):with_cr(Cond.none()))
    end,
  },
  {
    "folke/which-key.nvim",
    lazy = false,
    opts_extend = { "spec" },
    ---@type wk.Opts
    opts = {
      defaults = {},
      preset = "helix",
      spec = {
        {
          mode = { "n" },
          { "<leader>c", group = "coding" },
          { "<leader>d", group = "debug" },
          { "<leader>dt", group = "test" },
          { "<leader>f", group = "find" },
          { "<leader>g", group = "git" },
          { "<leader>l", group = "lsp" },
          { "<leader>q", group = "session" },
          { "<leader>t", group = "test" },
          { "<leader>x", group = "diagnostic" },
          { "<leader>s", group = "search" },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Keymaps (which-key)", },
    },

    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    -- stylua: ignore
    keys = {
      { "<c-\\>", function() require("toggleterm").toggle() end, desc = "Toggle Terminal", },
    },
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    opts = {
      provider_selector = function(_, ft, _)
        local lspWithOutFolding = { "markdown", "bash", "sh", "bash", "zsh", "css", "toml", "vue" }
        if vim.tbl_contains(lspWithOutFolding, ft) then
          return { "treesitter", "indent" }
        elseif ft == "html" then
          return { "indent" }
        elseif ft == "go" then
          return ""
        else
          return { "indent" }
        end
      end,
      open_fold_hl_timeout = 500,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local foldIcon = ""
        local hlgroup = "NonText"
        local newVirtText = {}
        local suffix = "  " .. foldIcon .. "  " .. tostring(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, hlgroup })
        return newVirtText
      end,
    },
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>fu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
    },
  },
  ---@module "flash"
  {
    "folke/flash.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    ---@type Flash.Config
    opts = {
      highlight = {
        background = false,
      },

      modes = {
        search = {
          enabled = true,
        },
        char = {
          jump_labels = true,
        },
      },
    },
  -- stylua: ignore
    keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
  },
  -- {
  --   "TheNoeTrevino/no-go.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   ft = "go",
  --   opts = {},
  -- },
}
