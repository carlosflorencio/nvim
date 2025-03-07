return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    enabled = false,
    config = function()
      require('kanagawa').setup {
        overrides = function(colors)
          local theme = colors.theme
          return {
            NormalFloat = { bg = 'none' },
            FloatBorder = { bg = 'none' },
            FloatTitle = { bg = 'none' },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = 'none',
              },
            },
          },
        },
      }
      vim.cmd [[colorscheme kanagawa-dragon]]
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme catppuccin-mocha]]
    end,
  },
  {
    'kvrohit/rasmus.nvim',
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme rasmus]]
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
    'tjdevries/colorbuddy.nvim',
    priority = 1000,
    enabled = false,
    config = function()
      vim.cmd [[colorscheme gruvbuddy]]
    end,
  },
  {
    '0xstepit/flow.nvim',
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[colorscheme flow]]
    end,
  },
  {
    'Mofiqul/vscode.nvim',
    priority = 1000,
    enabled = false,
    config = function()
      -- local c = require('vscode.colors').get_colors()
      -- print(vim.inspect(c.vscPopupBack))
      local colors = require('user.util.colors').colors

      require('vscode').setup {
        color_overrides = {
          vscBack = colors.bg,
          vscRed = colors.error,
          vscPopupBack = colors.bg,
          vscLeftDark = colors.bg,
          vscSplitDark = colors.lineSeparators,
        },
        group_overrides = {},
      }
      vim.cmd [[colorscheme vscode]]
      -- telescope results picker bg
      -- vim.api.nvim_set_hl(0, 'Directory', { bg = 'NONE' })
    end,
  },
  {
    'bluz71/vim-moonfly-colors',
    enabled = true,
    name = 'moonfly',
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.moonflyWinSeparator = 2 -- line instead of block
      vim.g.moonflyTransparent = true
    end,
    config = function()
      vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
        group = vim.api.nvim_create_augroup('custom_moonfly_theme', { clear = true }),
        pattern = '*',
        callback = function()
          vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
        end,
      })

      vim.cmd [[colorscheme moonfly]]
    end,
  },
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
          -- bg0 = '#111112',
          bg0 = '#1E1F1E',
          -- bg0 = '#1f2021',
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
