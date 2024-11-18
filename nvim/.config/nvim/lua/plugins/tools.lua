return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {},
      -- format_on_save = {
      --   lsp_fallback = true,
      --   timeout_ms = 10000,
      -- },
      format_after_save = {
        lsp_fallback = true,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {},
      custom_linters = {},
    },
    config = function(_, opts)
      local lint = require("lint")
      for name, impl in pairs(opts.custom_linters) do
        lint.linters[name] = impl
      end

      lint.linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
