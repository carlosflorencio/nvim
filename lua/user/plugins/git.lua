return {
  {
    -- reminder to commit more frequently
    "redve-dev/neovim-git-reminder",
    dependencies = { "rcarriga/nvim-notify" },
    event = "BufRead",
    opts = {
      delay = 5,
      -- required_changes = 30,
      remind_on_save_only = true,
    },
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local icons = require("user.ui").icons
      return {
        signs = {
          add = { text = icons.ui.LineLeft },
          change = { text = icons.ui.LineLeft },
          delete = { text = icons.ui.Triangle },
          topdelete = { text = icons.ui.Triangle },
          changedelete = { text = icons.ui.LineLeft },
          -- untracked = { text = "▏" },
        },
        update_debounce = 200,
        preview_config = {
          -- Options passed to nvim_open_win
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end

          map("n", "]c", gs.next_hunk, "Next Hunk")
          map("n", "[c", gs.prev_hunk, "Prev Hunk")
          map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
          map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
          map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
          map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
          map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
          map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
          map("n", "<leader>gb", function()
            gs.blame_line { full = true }
          end, "Blame Line")
          map("n", "<leader>gd", gs.diffthis, "Diff This")
          map("n", "<leader>ghD", function()
            gs.diffthis "~"
          end, "Diff This ~")
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        end,
      }
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>gg", ":LazyGit<CR>", desc = "LazyGit" },
    },
  },
}
