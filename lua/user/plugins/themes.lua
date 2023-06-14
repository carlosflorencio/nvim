return {
  {
    "uloco/bluloco.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.cmd.colorscheme "bluloco"
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
          styles = {
            -- remove italic
            comments = "NONE",
            keywords = "NONE",
          },
        },
        -- ...
      }

      vim.cmd "colorscheme github_dark"
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "EndOfBuffer" })
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
    "sainnhe/sonokai",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd.colorscheme "sonokai"
    end,
  },
}
