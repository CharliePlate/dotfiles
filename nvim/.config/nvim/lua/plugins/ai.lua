local function toggle_supermaven(on)
  local suggestion = require("supermaven-nvim.completion_preview")
  local binary = require("supermaven-nvim.binary.binary_handler")
  local preview = require("supermaven-nvim.completion_preview")

  local function disable_completion()
    suggestion.disable_inline_completion = true
    preview:dispose_inlay()
  end

  local turn_on_completion = function()
    suggestion.disable_inline_completion = false

    local buffer = vim.api.nvim_get_current_buf()
    local file_name = vim.api.nvim_buf_get_name(buffer)

    binary:on_update(buffer, file_name, "text_changed")
    binary:poll_once()
  end

  if on then
    turn_on_completion()
  else
    disable_completion()
  end
end

return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   event = "InsertEnter",
  --   opts = {
  --     suggestion = {
  --       keymap = {
  --         next = "jj",
  --         accept = "jl",
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "GeorgesAlkhouri/nvim-aider",
  --   cmd = "Aider",
  --   keys = {
  --     { "<leader>a/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
  --     { "<leader>as", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
  --     { "<leader>ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
  --     { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
  --     { "<leader>a+", "<cmd>Aider add<cr>", desc = "Add File" },
  --     { "<leader>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
  --     { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
  --     { "<leader>aR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
  --   },
  --   dependencies = {
  --     "folke/snacks.nvim",
  --     "catppuccin/nvim",
  --   },
  --   config = true,
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    opts = function()
      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          toggle_supermaven(false)
        end,
      })

      return {}
    end,
    keys = {
      {
        "jj",
        function()
          toggle_supermaven(true)
        end,
        desc = "Toggle Inline AI autocompletion",
        mode = { "i" },
      },
      {
        "jl",
        function()
          local suggestion = require("supermaven-nvim.completion_preview")
          suggestion.on_accept_suggestion(false)
          toggle_supermaven(false)
        end,
        desc = "Accept Inline AI autocompletion",
        mode = { "i" },
      },
    },
  },
  -- require("util.lang").addLspServer("copilot-language-server"),
  -- {
  --   "copilotlsp-nvim/copilot-lsp",
  --   init = function()
  --     vim.g.copilot_nes_debounce = 500
  --     vim.lsp.enable("copilot_ls")
  --     vim.keymap.set("n", "<tab>", function()
  --       local bufnr = vim.api.nvim_get_current_buf()
  --       local state = vim.b[bufnr].nes_state
  --       if state then
  --         local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
  --           or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
  --         return nil
  --       else
  --         return "<C-i>"
  --       end
  --     end, { desc = "Accept Copilot NES suggestion", expr = true })
  --   end,
  -- },
}
