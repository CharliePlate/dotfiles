local Fn = require("util.fn")

return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      local Cond = require("nvim-autopairs.conds")
      local Rule = require("nvim-autopairs.rule")
      local npairs = require("nvim-autopairs")

      npairs.setup(opts)

      npairs.add_rule(Rule(">[%w%s]*$", "^%s*</", {
        "templ",
      }):only_cr():use_regex(true))

      npairs.add_rule(Rule("<!--", "-->", "templ"):with_cr(Cond.none()))
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    opts = function()
      return {
        pickers = {
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            previewer = false,
            mappings = {
              i = {
                ["<c-d>"] = "delete_buffer",
              },
              n = {
                ["d"] = "delete_buffer",
              },
            },
          },
        },
      }
    end,
    -- stylua: ignore
		keys = {
      { "<leader>ff", function() require('telescope.builtin').find_files({cwd=Fn.lspRoot()}) end, desc = "Find Files (LSP)"},
			{ "<leader>fF", function() require('telescope.builtin').find_files() end, desc = "Find Files (Root)" },
      { "<leader>fg", function() require('telescope.builtin').live_grep({cwd=Fn.lspRoot()}) end, desc = "Grep (LSP)"},
      { "<leader>fG", function() require('telescope.builtin').live_grep() end, desc = "Grep (Root)" },
      { "<leader>fb", function() require('telescope.builtin').buffers() end, desc = "Buffers"}
		},
  },
  {
    "folke/which-key.nvim",
    lazy = false,
    opts_extend = { "spec" },
    ---@type wk.Opts
    opts = {
      defaults = {},
      preset = "helix",
      spec = {
        {
          mode = { "n" },
          { "<leader>c", group = "coding" },
          { "<leader>cp", group = "copilot chat" },
          { "<leader>d", group = "debug" },
          { "<leader>dt", group = "test" },
          { "<leader>f", group = "find" },
          { "<leader>g", group = "git" },
          { "<leader>l", group = "lsp" },
          { "<leader>q", group = "session" },
          { "<leader>t", group = "test" },
          { "<leader>x", group = "diagnostic" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
    },

    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<c-\\>",
        function()
          require("toggleterm").toggle()
        end,
        desc = "Toggle Terminal",
      },
      {
        "<leader>gg",
        function()
          require("util.git").lazy_git_toggle()
        end,
        desc = "LazyGit",
      },
    },
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    opts = {
      provider_selector = function(_, ft, _)
        local lspWithOutFolding = { "markdown", "bash", "sh", "bash", "zsh", "css", "toml", "vue" }
        if vim.tbl_contains(lspWithOutFolding, ft) then
          return { "treesitter", "indent" }
        elseif ft == "html" then
          return { "indent" } -- lsp & treesitter do not provide folds
        elseif ft == "go" then
          return ""
        else
          return { "indent" }
        end
      end,
      -- open opening the buffer, close these fold kinds
      -- use `:UfoInspect` to get available fold kinds from the LSP
      -- close_fold_kinds_for_ft = { "imports" },
      open_fold_hl_timeout = 500,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local foldIcon = ""
        local hlgroup = "NonText"
        local newVirtText = {}
        local suffix = "  " .. foldIcon .. "  " .. tostring(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, hlgroup })
        return newVirtText
      end,
    },
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>fu", "<cmd>UndotreeToggle<cr>", desc = "Undo Tree" },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      highlight = {
        background = false,
      },
      modes = {
        search = {
          enabled = true,
        },
      },
    },
  -- stylua: ignore
    keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = {
      {
        "<leader>a",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<leader>h",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<c-h>",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon to File 1",
      },
      {
        "<c-j>",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon to File 2",
      },
      {
        "<c-k>",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon to File 3",
      },
      {
        "<c-l>",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon to File 4",
      },
      {
        "<c-'>",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "Harpoon to File 5",
      },
    },
  },
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    },
  },
}
