local layout_config = {
  horizontal = {
    prompt_position = "bottom",
    preview_width = 0.55,
    results_width = 0.8,
  },
  vertical = {
    mirror = false,
  },
  width = 0.87,
  height = 0.87,
  preview_cutoff = 120,
}

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        dependencies = {
          "kkharji/sqlite.lua",
          {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
          },
        },
      },
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "benfowler/telescope-luasnip.nvim",
      "debugloop/telescope-undo.nvim",
    },
    cmd = "Telescope",
    config = function()
      local actions = require "telescope.actions"
      local telescope = require "telescope"

      telescope.setup {
        defaults = {
          file_ignore_patterns = { "node_modules" },
          path_display = { "truncate" },
          dynamic_preview_title = true,
          mappings = {
            n = {
              ["v"] = actions.select_vertical,
              ["x"] = actions.select_horizontal,
              ["t"] = actions.select_tab,
              ["L"] = actions.preview_scrolling_right,
              ["H"] = actions.preview_scrolling_left,
              ["<C-g>"] = actions.to_fuzzy_refine,
            },
            i = {
              ["<C-g>"] = actions.to_fuzzy_refine,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            layout_config = layout_config,
            previewer = nil, -- show previewer
          },
          live_grep = {
            -- @usage don't include the filename in the search results
            only_sort_text = true,
            layout_config = layout_config,
            previewer = nil, -- show previewer
          },
          buffers = {
            initial_mode = "normal",
            theme = "dropdown",
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          git_files = {
            hidden = true,
            show_untracked = true,
          },
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {
              -- extend mappings
              i = {
                ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt {
                  postfix = " --iglob ",
                },
              },
            },
          },
          smart_open = {
            ignore_patterns = { "*.git/*", "*/tmp/*", "*/dist/*" },
            match_algorithm = "fzf",
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
          undo = {
            initial_mode = "normal",
            side_by_side = false,
            mappings = {
              i = {
                ["<cr>"] = require("telescope-undo.actions").yank_additions,
                ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<C-cr>"] = require("telescope-undo.actions").restore,
              },
              n = {
                ["<cr>"] = require("telescope-undo.actions").yank_additions,
                ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<C-cr>"] = require("telescope-undo.actions").restore,
              },
            },
          },
        },
      }

      telescope.load_extension "fzf"
      telescope.load_extension "live_grep_args"
      telescope.load_extension "notify"
      telescope.load_extension "dap"
      telescope.load_extension "luasnip"
      telescope.load_extension "smart_open"
      telescope.load_extension "undo"
      telescope.load_extension "yank_history"
      -- telescope.load_extension "refactoring"
      telescope.load_extension "lazygit"
    end,
    keys = {
      {
        "<leader>fb",
        "<cmd>Telescope git_branches initial_mode=normal<cr>",
        desc = "Checkout Branch",
      },
      -- {
      --   "<leader>j",
      --   "<cmd>Telescope buffers show_all_buffers=true previewer=false ignore_current_buffer=true sort_mru=true<cr>",
      --   desc = "Open Buffers",
      -- },
      { "<leader>tt", "<cmd>Telescope diagnostics initial_mode=normal<cr>", desc = "LSP Diagnostics" },
      {
        "<leader>fg",
        "<cmd>Telescope git_status initial_mode=normal  previewer=false sort_mru=true<cr>",
        desc = "Git changed files",
      },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      {
        "<leader>fa",
        "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>",
        desc = "Find All Files",
      },
      {
        "<leader>ff",
        "<Cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true})<CR>",
        desc = "Find Project File",
      },
      {
        "<leader>fi",
        "<Cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        desc = "Find workspace symbols",
      },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
      { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      {
        "<leader>fr",
        "<cmd>Telescope oldfiles initial_mode=normal only_cwd=true<cr>",
        desc = "Open Recent Files",
      },
      { "<leader>fR", "<cmd>Telescope registers initial_mode=normal<cr>", desc = "Registers" },
      { "<leader>fw", "<cmd>Telescope live_grep_args<cr>", desc = "Grep Text" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
      { "<leader>fS", "<cmd>Telescope luasnip theme=dropdown<cr>", desc = "Snippets" },
      { "<leader>fu", "<cmd>Telescope undo initial_mode=normal<cr>", desc = "Undo list" },
      {
        "<leader>y",
        function()
          require("telescope").extensions.yank_history.yank_history { initial_mode = "normal" }
        end,
        desc = "Open Yank History",
        mode = { "n", "x" },
      },
      {
        "<leader>ft",
        "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
        desc = "Colorscheme with Preview",
      },
    },
  },
}
