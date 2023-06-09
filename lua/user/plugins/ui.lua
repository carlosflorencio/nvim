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
    enabled = true,
    event = "VeryLazy",
    -- keys = {
    --   {
    --     "<S-l>",
    --     "<cmd>BufferLineCycleNext<cr>",
    --     desc = "Next Tab",
    --   },
    --   {
    --     "<S-h>",
    --     "<cmd>BufferLineCyclePrev<cr>",
    --     desc = "Previous Tab",
    --   },
    -- },
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
            -- same color as nvim-tree bg
            highlight = "NvimTreeNormal",
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
      { "<leader>sm", "<cmd>WindowsMaximize<cr>", desc = "Maximize Window" },
    },
    event = "BufReadPost",
  },

  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup {
        excluded_filetypes = require("user.util.constants").disabled_filetypes,
      }
    end,
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

  {
    -- treesitter on popup menu, but I don't like the cmdline interface
    -- also, lsp signature is a bit odd
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = false,
      },
      messages = {
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
        signature = {
          enabled = false,
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        -- override = {
        --   ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        --   ["vim.lsp.util.stylize_markdown"] = true,
        --   ["cmp.entry.get_documentation"] = true,
        -- },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
}
