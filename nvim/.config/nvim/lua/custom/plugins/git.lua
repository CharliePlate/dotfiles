return {
  {
    ---@module "gitsigns"
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local Keys = require("util.keys")
        ---@type LazyKeysSpec[]
        -- stylua: ignore
        local maps = {
          { "]h", gs.next_hunk, buffer = buffer, desc = "Next Hunk" },
          { "[h", gs.prev_hunk, buffer = buffer, desc = "Prev Hunk" },
          { "<leader>gs", ":Gitsigns stage_hunk<CR>", buffer = buffer, desc = "Stage Hunk" },
          { "<leader>gs", ":Gitsigns stage_hunk<CR>", mode = "v", buffer = buffer, desc = "Stage Hunk" },
          { "<leader>gr", ":Gitsigns reset_hunk<CR>", buffer = buffer, desc = "Reset Hunk" },
          { "<leader>gr", ":Gitsigns reset_hunk<CR>", mode = "v", buffer = buffer, desc = "Reset Hunk" },
          { "<leader>gu", gs.undo_stage_hunk, buffer = buffer, desc = "Undo Stage Hunk" },
          { "<leader>gp", gs.preview_hunk, buffer = buffer, desc = "Preview Hunk" },
          { "<leader>gj", function() gs.blame_line({full = true}) end, buffer = buffer, desc = "Blame Line" },
          { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = "x", buffer = buffer, desc = "GitSigns Select Hunk" },
          { "ih", ":<C-U>Gitsigns select_hunk<CR>", mode = "o", buffer = buffer, desc = "GitSigns Select Hunk" },
        }

        Keys.addAndSet(maps)
      end,
    },
  },
  {
    ---@module "snacks"
    "folke/snacks.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>oi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>oI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>op", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>oP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    },
  },
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
    -- stylua: ignore
    keys = {
      { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git Diff (CodeDiff)" },
      { "<leader>gD", "<cmd>CodeDiff HEAD~1<cr>", desc = "Diff Against Last Commit" },
      { "<leader>gh", "<cmd>CodeDiff history<cr>", desc = "Git History (CodeDiff)" },
    },
    opts = {},
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "esmuellert/codediff.nvim", -- optional
      "folke/snacks.nvim", -- optional
    },
    cmd = "Neogit",
    opts = {
      filewatcher = { enabled = true },
    },
    config = function(_, opts)
      require("neogit").setup(opts)

      local neogit = require("neogit")

      -- Workaround: force refresh after Neogit operations.
      -- Uses vim.defer_fn to escape plenary async context and allow git to finish writing.
      vim.api.nvim_create_autocmd("User", {
        pattern = {
          "NeogitCommitComplete",
          "NeogitPushComplete",
          "NeogitPullComplete",
          "NeogitFetchComplete",
          "NeogitRebase",
          "NeogitMerge",
          "NeogitReset",
          "NeogitBranchReset",
          "NeogitStash",
          "NeogitCherryPick",
          "NeogitRevert",
          "NeogitBranchCheckout",
          "NeogitBranchCreate",
          "NeogitBranchDelete",
          "NeogitTagCreate",
          "NeogitTagDelete",
        },
        group = neogit.autocmd_group,
        callback = function()
          -- The status buffer instance is keyed by git worktree root, but
          -- vim.uv.cwd() may return a subdirectory. Resolve the git root
          -- so status.instance() can find the correct instance.
          vim.defer_fn(function()
            local ok, status = pcall(require, "neogit.buffers.status")
            if not ok then
              return
            end

            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            if git_root and git_root ~= "" then
              local instance = status.instance(vim.fs.normalize(git_root))
              if instance then
                instance:dispatch_refresh({ update_diffs = { "*:*" } }, "autocmd_fallback")
              end
            end
          end, 500)
        end,
      })
    end,
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
