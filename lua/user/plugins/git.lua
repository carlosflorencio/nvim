return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = function()
      local actions = require "diffview.actions"
      local nvimTreeApi = require "nvim-tree.api"

      require("diffview").setup {
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
        keymaps = {
          view = {
            {
              "n",
              "<leader>e",
              actions.toggle_files,
              {
                desc = "Toggle the file panel.",
              },
            },
            {
              "n",
              "<leader>l",
              actions.cycle_layout,
              {
                desc = "Cycle through available layouts.",
              },
            },
          },
          file_panel = {
            {
              "n",
              "<space>",
              actions.toggle_stage_entry,
              {
                desc = "Stage / unstage the selected entry.",
              },
            },
            {
              "n",
              "<C-w><C-f>",
              actions.goto_file_split,
              {
                desc = "Open the file in a new split",
              },
            },
            {
              "n",
              "<C-t>",
              actions.goto_file_tab,
              {
                desc = "Open the file in a new tabpage",
              },
            },
          },
        },
        hooks = {
          view_opened = function()
            -- nvimTreeApi.tree.close_in_this_tab()
            nvimTreeApi.tree.close()
            vim.cmd [[ WindowsDisableAutowidth ]]
          end,
          -- view_enter = function()
          --   nvimTreeApi.tree.close_in_this_tab()
          -- end,

          view_closed = function()
            nvimTreeApi.tree.toggle { focus = false }
            -- nvimTreeApi.tree.open()

            vim.cmd [[ WindowsEnableAutowidth ]]
          end,
        },
      }
    end,
    keys = {
      {
        "<leader>gD",
        function()
          local lib = require "diffview.lib"

          local view = lib.get_current_view()
          if view then
            -- Current tabpage is a Diffview; close it
            vim.cmd ":DiffviewClose"
            -- vim.cmd(":WindowsEnableAutowidth")
          else
            -- No open Diffview exists: open a new one
            -- vim.cmd(":WindowsDisableAutowidth")
            vim.cmd ":DiffviewOpen"
          end
        end,
        desc = "DiffView",
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
          add = { text = icons.ui.BoldLineLeft },
          change = { text = icons.ui.BoldLineLeft },
          delete = { text = icons.ui.Triangle },
          topdelete = { text = icons.ui.Triangle },
          changedelete = { text = icons.ui.BoldLineLeft },
          --untracked = { text = "▎" },
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

          local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

          map("n", "]c", gs.next_hunk, "Next Hunk")
          map("n", "[c", gs.prev_hunk, "Prev Hunk")
          map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
          map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
          map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
          map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
          map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
          map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
          map("n", "<leader>gb", function() gs.blame_line { full = true } end, "Blame Line")
          map("n", "<leader>gd", gs.diffthis, "Diff This")
          map("n", "<leader>ghD", function() gs.diffthis "~" end, "Diff This ~")
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
