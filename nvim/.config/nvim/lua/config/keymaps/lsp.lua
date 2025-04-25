local fn = require("util.fn")

local M = {}

-- stylua: ignore
M.keys = {
  { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
  { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
}

M.makeLspKeys = function(client, buffer)
  local Keys = require("util.keys")
  local Opts = fn.opts("nvim-lspconfig")
  local server_keys = Opts.servers[client.name] and Opts.servers[client.name].keys or {}
  local keymaps = vim.list_extend(M.keys, server_keys)
  Keys.addAndSet(keymaps)
end

return M
