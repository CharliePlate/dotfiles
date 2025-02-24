local function clangd_setup()
  if vim.fs.find("cs6340", { upward = true, path = vim.fn.getcwd() }) ~= nil then
    return { "docker", "exec", "-i", "cs6340", "clangd", "--background-index" }
  end
end

return {
  -- remove proto from th8is array
  -- filetypes = vim.tbl_filter(function(val)
  --   return val ~= "proto"
  -- end, require("lspconfig").clangd.document_config.default_config.filetypes),
  on_new_config = function(new_config)
    new_config.cmd = clangd_setup()
  end,
}
