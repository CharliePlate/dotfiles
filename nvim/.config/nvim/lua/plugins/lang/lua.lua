local Lang = require("util.lang")

return Lang.makeSpec({
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            { path = "wezterm-types", mods = { "wezterm" } },
            { path = "LazyVim", words = { "LazyVim" } },
            { path = "lazy.nvim", words = { "LazyVim" } },
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
      { "justinsgithub/wezterm-types", lazy = true }, -- optional `wezterm` typings
      -- {
      --   "saghen/blink.cmp",
      --   opts = {
      --     sources = {
      --       completion = {
      --         -- add lazydev to your completion providers
      --         enabled_providers = { "lazydev" },
      --       },
      --       providers = {
      --         lsp = {
      --           -- dont show LuaLS require statements when lazydev has items
      --           fallback_for = { "lazydev" },
      --         },
      --         lazydev = {
      --           name = "LazyDev",
      --           module = "lazydev.integrations.blink",
      --         },
      --       },
      --     },
      --   },
      -- },
    },
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      opts = function()
        local dap = require("dap")
        dap.configurations.lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
          },
        }

        dap.adapters.nlua = function(callback, config)
          callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
      end,
    },
  },
  Lang.addLspServer("lua_ls"),
  Lang.addFormatter({ lua = { "stylua" } }),
  Lang.addTreesitterFiletypes({ "lua" }),
})
