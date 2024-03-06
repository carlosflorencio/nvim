return {
  {
    "uloco/bluloco.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.cmd.colorscheme "bluloco"
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "Ignore" })
    end,
  },

  {
    "projekt0n/github-nvim-theme",
    enabled = false,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup {
        options = {
          hide_end_of_buffer = false,
          styles = {
            -- remove italic
            comments = "NONE",
            keywords = "NONE",
          },
        },
        -- ...
      }
      -- hide line
      -- vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#30363D", bg = "#30363D" })

      vim.cmd "colorscheme github_dark_dimmed"
    end,
  },

  {
    "catppuccin/nvim",
    enabled = false,
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd "colorscheme catppuccin-frappe"
    end,
  },

  {
    "AlexvZyl/nordic.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").load()

      vim.cmd "colorscheme nordic"
    end,
  },

  {
    "nyoom-engineering/oxocarbon.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd "colorscheme oxocarbon"
    end,
  },

  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup {
        styles = {
          comments = { italic = false },
        },
        dim_inactive = false,
      }
      vim.cmd.colorscheme "tokyonight-storm"
    end,
  },

  {
    -- JSX elements highlight not great, component and props with the same color
    "navarasu/onedark.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup {
        -- style = "warmer",
        ending_tildes = true,
        code_style = {
          comments = "none",
        },
      }
      require("onedark").load()
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "Ignore" })
    end,
  },

  {
    "sainnhe/sonokai",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "sonokai"
    end,
  },
}
