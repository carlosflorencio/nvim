return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    lazygit = {
      enabled = true,
      -- do not use nvim theme to lazygit
      configure = false,
    },
    picker = {
      layout = {
        -- --- Use the default layout or vertical if the window is too narrow
        -- preset = function()
        --   return vim.o.columns >= 120 and 'ivy' or 'vertical'
        -- end,
      },
      filter = {
        cwd = true,
      },
      layouts = {
        default = {
          -- bigger width, reduced preview
          layout = {
            box = 'horizontal',
            width = 0.9,
            min_width = 120,
            height = 0.9,
            {
              box = 'vertical',
              border = 'rounded',
              title = '{title} {live} {flags}',
              { win = 'input', height = 1, border = 'bottom' },
              { win = 'list', border = 'none' },
            },
            { win = 'preview', title = '{preview}', border = 'rounded', width = 0.4 },
          },
        },
      },
      sources = {
        file = {
          layout = {
            width = 1,
            -- min_width = 80,
            height = 1,
            -- min_height = 10,
          },
        },
      },
      icons = {
        files = {
          enabled = false,
        },
      },
      win = {
        input = {
          keys = {
            ['<c-t>'] = {
              'edit_tab',
              mode = { 'n', 'i' },
            },
          },
        },
        list = {
          keys = {
            ['<c-t>'] = 'edit_tab',
          },
        },
      },
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
          truncate = 200,
        },
      },
    },
    styles = {
      lazygit = {
        -- 0:0 is fullscreen
        width = 0,
        height = 0,
        relative = 'editor',
      },
    },
  },
  keys = {
    {
      '<leader>gg',
      function()
        Snacks.lazygit.open()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.smart()
      end,
      desc = 'Find files',
    },
    {
      '<leader>fw',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Find text',
    },
    {
      '<leader>fe',
      function()
        Snacks.picker.recent()
      end,
      desc = 'Find recent',
    },
    {
      '<leader>j',
      function()
        Snacks.picker.buffers {
          on_show = function()
            vim.cmd.stopinsert()
          end,
        }
      end,
      desc = 'Find buffers',
    },
    {
      '<leader>ls',
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = 'LSP Symbols',
    },
    {
      '<leader>lS',
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = 'LSP Workspace Symbols',
    },
    {
      '<leader>fh',
      function()
        Snacks.picker.help()
      end,
      desc = 'Find help',
    },
    {
      '<leader>fH',
      function()
        Snacks.picker.highlights()
      end,
      desc = 'Find highlights',
    },
    {
      '<leader>fg',
      function()
        Snacks.picker.git_status {
          on_show = function()
            vim.cmd.stopinsert()
          end,
        }
      end,
      desc = 'Find Git Status',
    },
    {
      '<leader>F',
      function()
        Snacks.picker()
      end,
      desc = 'Find text',
    },
  },
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function(args)
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command, dd(something)

        -- Create some toggle mappings
        -- Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
      end,
    })

    vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
      group = vim.api.nvim_create_augroup('custom_snacks_theme', { clear = true }),
      pattern = '*',
      callback = function()
        -- vim.api.nvim_set_hl(0, 'CursorColumn', { bg = 'NONE', link = 'NONE' })

        vim.api.nvim_set_hl(0, 'SnacksPickerInputCursorLine', { bg = 'NONE', link = 'NONE' })
      end,
    })
  end,
}
