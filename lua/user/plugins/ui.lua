return {

  {
    "uloco/bluloco.nvim",
    lazy = false,
    enabled = true,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.cmd.colorscheme "bluloco"
    end,
  },

  {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup {
        styles = {
          comments = { italic = false },
        },
        dim_inactive = false,
      }
      -- vim.cmd.colorscheme "tokyonight-storm"
    end,
  },

  {
    "navarasu/onedark.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "onedark"
    end,
  },

  {
    "Mofiqul/vscode.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup()
      require("vscode").load()
    end,
  },

  {
    "sainnhe/sonokai",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "sonokai"
    end,
  },

  {
    "rcarriga/nvim-notify",
    enabled = true,
    opts = {
      timeout = 1000,
      fps = 60,
      render = "minimal",
    },
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss {
            silent = true,
            pending = true,
          }
        end,
        desc = "Delete all Notifications",
      },
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require "user.util"
      if not Util.has "noice.nvim" then
        Util.on_very_lazy(function()
          vim.notify = require "notify"
        end)
      end
    end,
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    opts = {
      select = {
        get_config = function(opts)
          -- https://github.com/stevearc/dressing.nvim/issues/22#issuecomment-1067211863
          -- for codeaction, we want null-ls to be last
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/630
          if opts.kind == "codeaction" then
            return {
              telescope = {
                -- sorter = require 'telescope.sorters'.Sorter:new {
                --   scoring_function = function(_, _, line)
                --     if string.match(line, 'null-ls') then
                --       return 1
                --     else
                --       return 0
                --     end
                --   end,
                -- },
                initial_mode = "normal",
                -- copied from the telescope dropdown theme
                sorting_strategy = "ascending",
                layout_strategy = "center",
                layout_config = {
                  preview_cutoff = 1, -- Preview should always show (unless previewer = false)
                  width = 80,
                  height = 15,
                },
                borderchars = {
                  prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
                  results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
                  preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                },
              },
            }
          end
        end,
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load {
          plugins = { "dressing.nvim" },
        }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load {
          plugins = { "dressing.nvim" },
        }
        return vim.ui.input(...)
      end
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    cond = function()
      return vim.g.started_by_firenvim == nil
    end,
    event = "VeryLazy",
    keys = {
      {
        "<S-l>",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next Tab",
      },
      {
        "<S-h>",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Previous Tab",
      },
    },
    opts = {
      options = {
        truncate_names = false,
        mode = "tabs",
        sort_by = "tabs",
        show_tab_indicators = false,
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "thick",
        name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
          local path = vim.fn.fnamemodify(buf.path, ":.")
          return require("user.util").getShortenPath(path, 3)
          -- return vim.fn.pathshorten(path, 5)
          -- return path
        end,
        indicator = {
          style = "none",
        },
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "undotree",
            text = "Undotree",
            highlight = "PanelHeading",
            padding = 1,
          },
          {
            filetype = "NvimTree",
            -- text = "Explorer",
            text = "",
            -- highlight = "PanelHeading",
            padding = 0,
          },
          {
            filetype = "DiffviewFiles",
            text = "Diff View",
            highlight = "PanelHeading",
            padding = 1,
          },
          {
            filetype = "flutterToolsOutline",
            text = "Flutter Outline",
            highlight = "PanelHeading",
          },
          {
            filetype = "lazy",
            text = "Lazy",
            highlight = "PanelHeading",
            padding = 1,
          },
        },
      },
    },
  },

  -- show colorcolumn when line is too long on insert mode
  {
    "Bekaboo/deadcolumn.nvim",
    event = "BufReadPost",
  },

  {
    -- expand windows
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      -- "anuvyklack/animation.nvim"
    },
    opts = {},
    cmd = { "WindowsMaximize", "WindowsEqualize", "WindowsToggleAutowidth" },
    keys = {
      { "<leader>sm", "<cmd>WindowsMaximize<cr>", desc = "Maximize Window" },
    },
    event = "BufReadPost",
  },

  {
    "petertriho/nvim-scrollbar",
    cond = function()
      return vim.g.started_by_firenvim == nil
    end,
    opts = {
      excluded_filetypes = {
        "prompt",
        "oil",
        "TelescopePrompt",
        "noice",
        "NvimTree",
        "lazy",
        "lir",
      },
    },
    event = "VeryLazy",
  },

  {
    "karb94/neoscroll.nvim",
    enabled = true,
    event = "BufRead",
    opts = {
      mappings = { "<C-u>", "<C-d>" },
    },
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      --char = "▏",
      char = "",
      filetype_exclude = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "lir",
        "NvimTree",
        "neogitstatus",
        "aerial",
        "lspinfo",
        "man",
        "checkhealth",
        "",
      },
      show_trailing_blankline_indent = false,
      show_current_context = true,
    },
  },

  {
    -- highlight colors
    -- :CccPick - Color picker
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    config = function()
      local ccc = require "ccc"
      -- local mapping = ccc.mapping

      ccc.setup {
        -- Your preferred settings
        -- Example: enable highlighter
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
      }
    end,
  },
}
