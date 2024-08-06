return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    enabled = true,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme catppuccin-mocha]]
    end,
  },
  -- {
  --   'scottmckendry/cyberdream.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   enabled = require('user.util.env').is_iterm2(),
  --   config = function()
  --     require('cyberdream').setup {
  --       transparent = true,
  --     }

  --     vim.cmd [[colorscheme cyberdream]]
  --   end,
  -- },
  {
    'navarasu/onedark.nvim',
    -- enabled = require('user.util.env').is_iterm2(),
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'darker', -- warm, darker
        ending_tildes = true,
        code_style = {
          comments = 'none',
        },
        cmp_itemkind_reverse = false,

        colors = {
          -- darker bg color
          -- https://github.com/navarasu/onedark.nvim/blob/master/lua/onedark/palette.lua#L32
          bg0 = '#1f2021',
          bg1 = '#2a2b2c',
          bg3 = '#2a2b2c',
        },
        highlights = {
          ['Visual'] = { bg = '#254b4f' },
        },
      }
      require('onedark').load()
      -- vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', { link = 'Ignore' })
      vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'NONE' }) -- cmp boder
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
