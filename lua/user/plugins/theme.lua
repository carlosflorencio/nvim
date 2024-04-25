return {
  {
    'navarasu/onedark.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'darker',
        ending_tildes = true,
        code_style = {
          comments = 'none',
        },
      }
      require('onedark').load()
      -- vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', { link = 'Ignore' })
      vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'NONE' })
    end,
  },

  {
    'sainnhe/gruvbox-material',
    enabled = false,
    priority = 1000,
    config = function()
      -- vim.o.background = 'dark' -- or "light" for light mode
      vim.cmd [[colorscheme gruvbox-material]]
    end,
  },

  {
    'projekt0n/github-nvim-theme',
    enabled = false,
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {
        options = {
          hide_end_of_buffer = false,
          styles = {
            -- remove italic
            comments = 'NONE',
            keywords = 'NONE',
          },
        },
        -- ...
      }
      -- hide line
      -- vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#30363D", bg = "#30363D" })

      vim.cmd 'colorscheme github_dark_dimmed'
    end,
  },

  {
    'uloco/bluloco.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    dependencies = { 'rktjmp/lush.nvim' },
    config = function()
      vim.cmd.colorscheme 'bluloco'
      vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', { link = 'Ignore' })
    end,
  },

  {
    'tiagovla/tokyodark.nvim',
    enabled = false,
    priority = 1000,
    config = function()
      require('tokyodark').setup {
        -- styles = {
        --   comments = { italic = false },
        -- },
        -- dim_inactive = false,
      }
      vim.cmd [[colorscheme tokyodark]]
    end,
  },
}
