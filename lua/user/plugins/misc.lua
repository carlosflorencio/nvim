return {
  {
    "wakatime/vim-wakatime",
    lazy = false,
  },

  {
    -- generate github links
    "ruifm/gitlinker.nvim",
    -- event = "BufRead",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("gitlinker").setup {
        opts = {
          add_current_line_on_normal_mode = true,
          action_callback = require("gitlinker.actions").open_in_browser,
          print_url = true,
          mappings = nil,
        },
      }
    end,
    keys = {
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url "n"
        end,
        desc = "Create github link",
      },
      {
        "<leader>gy",
        function()
          require("gitlinker").get_buf_range_url "v"
        end,
        mode = "v",
        desc = "Create github link",
      },
    },
  },

  {
    "stevearc/oil.nvim",
    opts = {
      default_file_explorer = false,
      float = {
        -- Padding around the floating window
        -- padding = 3,
        max_width = 100,
        max_height = 30,
        -- border = "rounded",
        win_options = {
          winblend = 0,
          winhighlight = "NormalFloat:Normal,FloatBorder:Normal",
        },
      },
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["l"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["q"] = "actions.close",
        ["<esc>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["h"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["I"] = "actions.toggle_hidden",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>;", "<cmd>Oil --float<cr>", desc = "Oil" },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup {
        width = 150,
        plugins = {
          options = {
            enabled = false,
            ruler = true, -- disables the ruler text in the cmd line area
            showcmd = true, -- disables the command in the last line of the screen
          },
          gitsigns = { enabled = true }, -- disables git signs
        },
        on_close = function()
          vim.o.cmdheight = 0
          -- vim.cmd "set cc=80"
        end,
        on_open = function()
          vim.o.cmdheight = 1
          -- vim.cmd "set cc="
        end,
      }
    end,
    keys = {
      { "<leader>tz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
      { "<leader>sm", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
  },

  -- -- makes some plugins dot-repeatable like leap
  -- { "tpope/vim-repeat", event = "VeryLazy" },

  {
    -- code screenshots
    "desilinguist/silicon.lua",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      font = "JetBrainsMono Nerd Font",
      padHoriz = 50, -- Horizontal padding
      padVert = 50, -- vertical padding
    },
    keys = {
      {
        "<leader>sp",
        function()
          require("silicon").visualise_api { to_clip = true }
        end,
        desc = "Silicon code screenshot",
        mode = "v",
      },
    },
  },

  {
    "LunarVim/bigfile.nvim",
    opts = {
      features = { -- features to disable
        "indent_blankline",
        "illuminate",
        -- "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
      },
    },
    event = { "FileReadPre", "BufReadPre", "User FileOpened" },
  },

  {
    -- open links with gx
    "chrishrb/gx.nvim",
    event = { "BufEnter" },
    config = true, -- default settings
  },

  -- lose bad habits
  -- TODO: on remove, re-enable keymaps for dealing with word wrap
  {
    "m4xshen/hardtime.nvim",
    enabled = false,
    lazy = false,
    opts = {
      max_count = 3,
      disabled_keys = {},
    },
  },

  {
    "ThePrimeagen/harpoon",
    -- event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      menu = {
        width = 100,
      },
      mark_branch = true,
    },
    keys = {
      {
        "<leader>m",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon mark file",
      },
      {
        "<leader>k",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Harpoon file navigation",
      },
    },
  },
}
