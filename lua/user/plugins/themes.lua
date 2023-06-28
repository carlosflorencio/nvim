return {
  {
    "uloco/bluloco.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.cmd.colorscheme "bluloco"
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "Ignore" })
    end,
  },

  {
    "projekt0n/github-nvim-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    enabled = true,
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

      vim.cmd "colorscheme github_dark"
      -- hide line
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#30363D", bg = "#30363D" })
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
    enabled = false,
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
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "EndOfBuffer" })
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
