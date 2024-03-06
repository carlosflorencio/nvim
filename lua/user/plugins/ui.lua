return {

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
    enabled = true,
    opts = {
      select = {
        get_config = function(opts)
          if opts.kind == "custom_builtin" then
            return {
              backend = "builtin",
            }
          end

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
    enabled = true,
    event = "VeryLazy",
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
        show_duplicate_prefix = false,
        tab_size = 5,
        name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
          if buf.name == "[No Name]" then
            return ""
          end

          local path = vim.fn.fnamemodify(buf.path, ":.")
          return require("user.util").getShortenPath(path, 3)
        end,
        indicator = {
          style = "none",
        },
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "NvimTree",
            text = "",
            -- same color as nvim-tree bg
            highlight = "NvimTreeNormal",
            padding = 0,
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
    enabled = true,
    dependencies = {
      "anuvyklack/middleclass",
      -- "anuvyklack/animation.nvim"
    },
    opts = {
      autowidth = {
        winwidth = 30,
      },
    },
    cmd = { "WindowsMaximize", "WindowsEqualize", "WindowsToggleAutowidth" },
    keys = {
      { "<leader>sM", "<cmd>WindowsMaximize<cr>", desc = "Maximize Window" },
    },
    event = "BufReadPost",
  },

  {
    -- smooth scrolling
    "karb94/neoscroll.nvim",
    enabled = false,
    event = "BufRead",
    opts = {
      mappings = { "<C-u>", "<C-d>" },
    },
  },

  {
    -- indent guides for Neovim
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    version = "^2",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "",
      filetype_exclude = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "gitcommit",
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

  {
    -- cursorline only for the active window
    "tummetott/reticle.nvim",
    enabled = true,
    -- lazy = false,
    event = "VeryLazy", -- lazyload the plugin if you like
    opts = {
      -- add options here if you want to overwrite defaults
      ignore = {
        cursorline = {
          "NvimTree",
        },
      },
    },
  },
}
