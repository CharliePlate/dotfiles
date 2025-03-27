local function merge_tables(base, overrides)
  if overrides then
    for k, v in pairs(overrides) do
      if type(v) == "table" and type(base[k]) == "table" then
        merge_tables(base[k], v)
      else
        base[k] = v
      end
    end
  end
end

local function create_openrouter_ai(model, opts)
  local config = {
    __inherited_from = "openai",
    endpoint = "https://openrouter.ai/api/v1",
    model = model,
    timeout = 30000,
    temperature = 0,
    api_key_name = "OPENROUTER_API_KEY",
    disable_tools = false,
  }
  merge_tables(config, opts)
  return config
end

local function get_avante_vendors()
  return {
    deepseek_r1 = create_openrouter_ai("deepseek/deepseek-r1-zero:free", { disable_tools = true }),
    deepseek_v3 = create_openrouter_ai("deepseek/deepseek-chat-v3-0324:free", { disable_tools = true }),
    gemini_flash = create_openrouter_ai("google/gemini-2.0-flash-exp:free"),
    llama = create_openrouter_ai("meta-llama/llama-3.3-70b-instruct:free"),
    gemini_2_5 = create_openrouter_ai("google/gemini-2.5-pro-exp-03-25:free"),
    claude_3_7 = create_openrouter_ai("anthropic/claude-3.7-sonnet"),
  }
end

local function create_codecompanion_adapter(model_name, overrides)
  local base_config = {
    env = {
      url = "https://openrouter.ai/api",
      api_key = "OPENROUTER_API_KEY",
    },
    schema = {
      model = {
        default = model_name,
      },
    },
  }
  merge_tables(base_config, overrides)
  return function()
    return require("codecompanion.adapters").extend("openai_compatible", base_config)
  end
end

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    build = "make",
    opts = {
      provider = "gemini",
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        model = "gemini-2.5-pro-exp-03-25",
        timeout = 30000,
        temperature = 0,
      },
      vendors = get_avante_vendors(),
      behaviour = {
        enable_cursor_planning_mode = true,
        enable_token_counting = true,
      },
      cursor_applying_provider = "gemini_flash",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
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
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
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
  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {
  --     strategies = {
  --       chat = {
  --         adapter = "gemini_2_5",
  --       },
  --     },
  --     adapters = {
  --       gemini_2_5 = create_codecompanion_adapter("google/gemini-2.5-pro-exp-03-25:free"),
  --       deepseek_r1 = create_codecompanion_adapter("deepseek/deepseek-r1-zero:free"),
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "j-hui/fidget.nvim",
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       ft = { "markdown", "codecompanion" },
  --     },
  --   },
  -- },
}
