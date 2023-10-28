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

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
    opts = {
      default_mappings = false,
      disable_diagnostics = true,
    },
    lazy = false,
    keys = {
      {
        "<leader>gC",
        "<cmd>GitConflictListQf<cr>",
        desc = "Open git conflict list",
      },
      {
        "<leader>gc",
        function()
          vim.ui.select({
            "Ours (Current)",
            "Theirs (Incoming)",
            "Both",
            "None",
          }, {
            prompt = "Git Conflict",
            format_item = function(item)
              return "Choose " .. item
            end,
            kind = "custom_builtin",
          }, function(_, idx)
            if idx == nil then
              return
            end

            local cmds = {
              "GitConflictChooseOurs",
              "GitConflictChooseTheirs",
              "GitConflictChooseBoth",
              "GitConflictChooseNone",
            }

            vim.cmd(cmds[idx])
          end)
        end,
        desc = "Git conflict resolve",
      },
      -- {
      --   "<leader>gco",
      --   "<Plug>(git-conflict-ours)",
      --   desc = "Git conflict: Choose Ours (Current)",
      -- },
      -- {
      --   "<leader>gct",
      --   "<Plug>(git-conflict-theirs)",
      --   desc = "Git conflict: Choose Theirs (Incoming)",
      -- },
      -- {
      --   "<leader>gcb",
      --   "<Plug>(git-conflict-both)",
      --   desc = "Git conflict: Choose Both",
      -- },
      -- {
      --   "<leader>gcn",
      --   "<Plug>(git-conflict-none)",
      --   desc = "Git conflict: Choose None",
      -- },
      {
        "]x",
        "<Plug>(git-conflict-next-conflict)",
        desc = "Git conflict: Go to next",
      },
      {
        "[x",
        "<Plug>(git-conflict-prev-conflict)",
        desc = "Git conflict: Go to prev",
      },
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

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewFileHistory", "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { ",HH", "<cmd>DiffviewFileHistory<cr>", desc = "Git Repo History", mode = "n" },
      { ",hh", "<cmd>DiffviewFileHistory --follow %<cr>", desc = "Git File History", mode = "n" },
      { ",hh", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = "Git History", mode = "v" },
      { ",hc", "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },
    },
  },
}
