return {
  filetypes = vim.tbl_filter(function(val)
    return val ~= "proto"
  end, require("lspconfig").clangd.document_config.default_config.filetypes),
  on_new_config = function(new_config)
    -- check to see if I am in the /school/cs6340 folder
    if vim.fs.find("cs6340", { upward = true, path = vim.fn.getcwd() }) ~= nil then
      -- if I am, set the cmd to use docker
      new_config.cmd = { "docker", "exec", "-i", "cs6340", "clangd", "--background-index" }
    end
  end,
}
