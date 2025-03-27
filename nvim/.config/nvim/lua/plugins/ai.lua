return {
  ---@module 'avante'
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = "*",
    build = "make",
    ---@type avante.Config
    ---@diagnostic disable-next-line
    opts = {
      provider = "gemini_2_5",
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        model = "gemini-2.0-flash",
        timeout = 30000,
        temperature = 0,
      },
      vendors = {
        deepseek_r1 = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "deepseek/deepseek-r1-distill-llama-70b:free",
          timeout = 30000,
          temperature = 0,
          disable_tools = true,
        },
        deepseek_v3 = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          model = "deepseek/deepseek-chat-v3-0324:free",
          timeout = 30000,
          temperature = 0,
          api_key_name = "OPENROUTER_API_KEY",
          disable_tools = true,
        },
        gemini_flash = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          model = "google/gemini-2.0-flash-exp:free",
          timeout = 30000,
          temperature = 0,
          api_key_name = "OPENROUTER_API_KEY",
        },
        llama = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          model = "meta-llama/llama-3.3-70b-instruct:free",
          timeout = 30000,
          temperature = 0,
          api_key_name = "OPENROUTER_API_KEY",
        },
        gemini_2_5 = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          model = "google/gemini-2.5-pro-exp-03-25:free",
          timeout = 30000,
          temperature = 0,
          api_key_name = "OPENROUTER_API_KEY",
        },
      },
      behaviour = {
        jump_result_buffer_on_finish = true,
        enable_cursor_planning_mode = true,
        enable_token_counting = false,
        -- auto_suggestions = true,
      },
      cursor_applying_provider = "llama",
      -- auto_suggestions_provider = "gemini",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      {
        "saghen/blink.cmp",
        dependencies = {
          "Kaiser-Yang/blink-cmp-avante",
        },
        opts = {
          sources = {
            default = { "avante" },
            providers = {
              avante = {
                module = "blink-cmp-avante",
                name = "Avante",
                opts = {},
              },
            },
          },
        },
      },
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        keymap = {
          next = "jj",
          accept = "jl",
        },
      },
    },
  },
}
