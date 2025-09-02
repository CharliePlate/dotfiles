local vue_language_server_path = vim.fn.expand("$MASON/packages")
  .. "/vue-language-server"
  .. "/node_modules/@vue/language-server"
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

return {
  keys = {
    {
      "<leader>cf",
      function()
        vim.lsp.buf.code_action({
          apply = true,
          context = {
            only = { "refactor.rewrite" },
            diagnostics = {},
          },
        })
      end,
      desc = "Code action: refactor",
    },
  },

  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
}
