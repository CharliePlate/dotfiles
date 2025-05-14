return {
  filetypes = { "vue" },
  init_options = {
    vue = {
      hybridMode = false,
    },
    typescript = {
      tsdk = "/Users/charlieplate/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib",
    },
  },
  before_init = function(params, config)
    local lib_path = vim.fs.find("node_modules/typescript/lib", { path = new_root_dir, upward = true })[1]
    if lib_path then
      config.init_options.typescript.tsdk = lib_path
    end
  end,
}
