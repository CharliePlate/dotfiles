local fn = require("util.fn")

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      { "williamboman/mason-lspconfig.nvim" },
    },
    event = "LazyFile",
    opts = {
      servers = {},
      inlayHints = {},
      ensure_installed = {},
    },
    config = function(_, opts)
      local register_capability = vim.lsp.handlers["client/registerCapability"]

      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        require("config.keymaps.lsp").makeLspKeys(client, buffer)

        return ret
      end

      local signs = { text = {} }
      for name, icon in pairs(require("util.icons").diagnostics) do
        signs.text[vim.diagnostic.severity[name:upper()]] = icon
      end

      vim.diagnostic.config({
        signs = signs,
        virtual_text = true,
        underline = true,
        update_in_insert = false,
      })

      fn.lspOnAttach(function(client, _)
        if opts.inlayHints[client.name] then
          if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true)
          end
        end
      end)

      -- Set up keybindings
      fn.lspOnAttach(function(client, buffer)
        require("config.keymaps.lsp").makeLspKeys(client, buffer)
      end)

      local mason = require("mason-lspconfig")
      local function setup(server_name)
        local server_opts = opts.servers[server_name] or {}
        if opts.servers[server_name] and opts.servers[server_name].setup ~= nil then
          opts.servers[server_name].setup(server_opts)
        else
          vim.lsp.config(server_name, server_opts)
        end

        if opts.servers[server_name] and opts.servers[server_name].autocmds ~= nil then
          opts.servers[server_name].autocmds()
        end

        if opts.servers[server_name] and opts.servers[server_name].keys ~= nil then
          fn.lspOnAttach(function(_, buffer)
            local Keys = require("util.keys")
            for _, key in ipairs(opts.servers[server_name].keys) do
              key.buffer = buffer
            end
            Keys.addAndSet(opts.servers[server_name].keys)
          end)
        end
      end

      for server_name, _ in pairs(opts.servers) do
        setup(server_name)
      end

      mason.setup({
        automatic_enable = true,
        ensure_installed = opts.ensure_installed,
      })
    end,
    keys = {
      { "<leader>li", "<cmd>Mason<cr>", "Mason" },
      { "<leader>lI", "<cmd>LspInfo<cr>", "Lsp Info" },
      { "<leader>lR", "<cmd>LspRoot<cr>", "Lsp Root" },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    opts = {
      input_buffer_type = "dressing",
    },
  },
}
