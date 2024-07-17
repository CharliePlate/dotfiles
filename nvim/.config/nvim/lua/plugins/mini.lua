local root_names = { ".git", "Makefile", "Cargo.toml", "go.mod", "lazy-lock.json" }

function Root()
  local root = require("mini.misc").find_root(0, root_names)
  if not root then
    return
  end

  return root
end

return {
  {
    "echasnovski/mini.misc",
    config = function()
      require("mini.misc").setup()
      MiniMisc.setup_auto_root(root_names)
      vim.api.nvim_exec_autocmds("User", { pattern = "RootLoaded" })
      vim.api.nvim_create_user_command("LspRoot", function()
        print(require("mini.misc").find_root(0, root_names))
      end, { desc = "Prints the LSP Root" })
    end,
    init = function()
      require("mini.misc").setup()
      local bid = vim.fn.bufadd(vim.fn.getcwd())
      local root = MiniMisc.find_root(bid, root_names)
      if not root then
        return
      end

      ---@diagnostic disable-next-line
      vim.fn.chdir(root)
    end,
  },
  {
    "echasnovski/mini.icons",
    opts = {},
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "echasnovski/mini.files",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
      mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "<cr>",
        go_out = "-",
        go_out_plus = "H",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      local show_dotfiles = true
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        require("mini.files").refresh({ content = { filter = new_filter } })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesWindowUpdate",
        callback = function(args)
          vim.wo[args.data.win_id].relativenumber = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesActionRename",
        callback = function(event)
          local clients = vim.lsp.get_clients()
          for _, client in ipairs(clients) do
            if client.supports_method("workspace/willRenameFiles") then
              ---@diagnostic disable-next-line: invisible
              local resp = client.request_sync("workspace/willRenameFiles", {
                files = {
                  {
                    oldUri = vim.uri_from_fname(event.data.from),
                    newUri = vim.uri_from_fname(event.data.to),
                  },
                },
              }, 1000, 0)
              if resp and resp.result ~= nil then
                vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
              end
            end
          end
        end,
      })
    end,
    keys = {
      {
        "-",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0))
          require("mini.files").reveal_cwd()
        end,
        desc = "File Explorer",
      },
    },
  },
}