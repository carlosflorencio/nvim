return {
  {
    'nvim-lualine/lualine.nvim',
    opts = function()
      local components = require 'user.plugins.lualine.components'
      require 'user.plugins.lualine.wakatime'

      return {
        options = {
          theme = 'auto',
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
            Lualine_get_wakatime,
            components.location,
            require 'user.plugins.lualine.fancy-lsp-servers',
            'searchcount',
          },
          -- lualine_y = {
          --   components.diagnostics,
          -- },
          lualine_z = {},
        },
        extensions = {},
      }
    end,
  },
}
