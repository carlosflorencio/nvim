return {
  {
    'linrongbin16/lsp-progress.nvim',
    lazy = true,
    config = function()
      require('lsp-progress').setup {
        -- 50ms initial update time is too fast
        event_update_time_limit = 100,
        -- after initial load, we don't want to update progress that often
        -- because this will cause a lualine refresh
        regular_internal_update_time = 5000,
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local components = require 'user.plugins.lualine.components'
      require 'user.plugins.lualine.wakatime'

      require('lualine').setup {
        options = {
          -- theme = 'auto',
          globalstatus = true,
          refresh = {
            statusline = 2000,
          },
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = { 'dashboard', 'lazy', 'alpha', 'NvimTree', 'TelescopePrompt' },
          },
          ignore_focus = {
            'NvimTree',
            'chatgpt-input',
            'oil',
            'lir',
            'dapui_watches',
            'dapui_breakpoints',
            'dapui_scopes',
            'dapui_console',
            'dapui_stacks',
            'dap-repl',
          },
        },

        sections = {
          lualine_b = { components.branch },
          lualine_c = {
            components.filetype,
            components.diagnostics,
            require 'user.plugins.lualine.diagnostic-line',
            {
              function()
                return require('package-info').get_status()
              end,
              cond = function()
                return package.loaded['package-info'] ~= nil
              end,
            },
            components.python_env,
          },
          lualine_x = {
            function()
              return require('lsp-progress').progress {
                format = function(messages)
                  return #messages > 0 and table.concat(messages, ' ') or ''
                end,
              }
            end,
            components.cwd,
            Lualine_get_wakatime,
            components.location,
            require 'user.plugins.lualine.fancy-lsp-servers',
            -- require 'user.plugins.lualine.yamlls',
            'searchcount',
          },
          -- lualine_y = {
          --   components.diagnostics,
          -- },
          lualine_z = {},
        },
        extensions = {},
      }

      -- listen lsp-progress event and refresh lualine
      vim.api.nvim_create_augroup('lualine_augroup', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = 'lualine_augroup',
        pattern = 'LspProgressStatusUpdated',
        callback = function()
          require('lualine').refresh()
        end,
      })
    end,
  },
}
