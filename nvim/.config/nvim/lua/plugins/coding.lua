local fn = require("util.fn")

return {
  { "numToStr/Comment.nvim", opts = {} },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  {
    "saghen/blink.cmp",
    lazy = false,
    build = "cargo build --release",
    -- version = "*",
    opts_extend = {
      "sources.default",
      "sources.compat",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    ---@diagnostic disable
    opts = {
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "normal",
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          border = "rounded",
          winblend = vim.o.pumblend,
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          window = {
            border = "rounded",
          },
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },
      sources = {
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        enabled = true,
      },
      keymap = {
        preset = "super-tab",
      },
    },
    config = function(_, opts)
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --     "hrsh7th/cmp-cmdline",
  --     "L3MON4D3/LuaSnip",
  --     "saadparwaiz1/cmp_luasnip",
  --   },
  --   event = { "InsertEnter", "CmdLineEnter" },
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --     return {
  --       snippet = {
  --         expand = function(args)
  --           require("luasnip").lsp_expand(args.body)
  --         end,
  --       },
  --       window = {
  --         completion = cmp.config.window.bordered(),
  --         documentation = cmp.config.window.bordered(),
  --       },
  --       sources = cmp.config.sources(fn.mergeArrays(opts.sources or {}, {
  --         { name = "nvim_lsp", priority = 1000 },
  --         { name = "luasnip", priority = 750 },
  --         { name = "path", priority = 500 },
  --         { name = "buffer", priority = 250 },
  --       })),
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-b>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-f>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<C-e>"] = cmp.mapping.abort(),
  --         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --         ["<S-CR>"] = cmp.mapping.confirm({
  --           behavior = cmp.ConfirmBehavior.Replace,
  --           select = true,
  --         }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --         ["<C-CR>"] = function(fallback)
  --           cmp.abort()
  --           fallback()
  --         end,
  --       }),
  --       completion = {
  --         completeopt = "menu,menuone,noinsert",
  --       },
  --       formatting = {
  --         format = function(_, item)
  --           local icons = require("util.icons").kinds
  --           if icons[item.kind] then
  --             item.kind = icons[item.kind] .. item.kind
  --           end
  --           return item
  --         end,
  --       },
  --       experimental = {
  --         ghost_text = {
  --           hl_group = "CmpGhostText",
  --         },
  --       },
  --     }
  --   end,
  --   config = function(_, opts)
  --     vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  --     require("cmp").setup(opts)
  --     local cmp = require("cmp")
  --     ---@diagnostic disable-next-line: missing-fields
  --     cmp.setup.cmdline({ "/", "?" }, {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = {
  --         { name = "buffer" },
  --       },
  --     })
  --     ---@diagnostic disable-next-line: missing-fields
  --     cmp.setup.cmdline(":", {
  --       mapping = cmp.mapping.preset.cmdline(),
  --       sources = cmp.config.sources({
  --         { name = "path" },
  --       }, {
  --         { name = "cmdline" },
  --       }),
  --     })
  --   end,
  -- },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true,
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle window.size.width=30 window.pos=right<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
