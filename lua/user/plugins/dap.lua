return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },
      { 'leoluz/nvim-dap-go', opts = {} },
      {
        'Weissle/persistent-breakpoints.nvim',
        event = 'BufReadPost',
        opts = {
          load_breakpoints_event = { 'BufReadPost' },
        },
        keys = {
          {
            ',bb',
            "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>",
            desc = 'Toggle breakpoint',
          },
          {
            ',bc',
            "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<CR>",
            desc = 'Conditional breakpoint',
          },
          {
            ',bd',
            "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>",
            desc = 'Delete all breakpoints',
          },
        },
      },
      {
        'ofirgall/goto-breakpoints.nvim',
        keys = {
          {
            ']b',
            function()
              require('goto-breakpoints').next()
            end,
            desc = 'Next breakpoint',
          },
          {
            '[b',
            function()
              require('goto-breakpoints').prev()
            end,
            desc = 'Previous breakpoint',
          },
        },
      },
      {
        'igorlfs/nvim-dap-view',
        opts = {
          winbar = {
            default_section = 'scopes',
            controls = {
              enabled = true,
              position = 'left',
            },
          },
          windows = {
            terminal = {
              -- `go` is known to not use the terminal.
              hide = { 'go' },
            },
          },
          switchbuf = 'useopen',
        },
        keys = {
          { ',dw', '<cmd>DapViewWatch<CR>', desc = 'DAP view watch variable under cursor' },
        },
      },
    },
    config = function()
      local dap, dv = require 'dap', require 'dap-view'

      -- auto open dap view
      dap.listeners.before.attach['dap-view-config'] = function()
        dv.open()
      end
      dap.listeners.before.launch['dap-view-config'] = function()
        dv.open()
      end
      dap.listeners.before.event_terminated['dap-view-config'] = function()
        dv.close()
      end
      dap.listeners.before.event_exited['dap-view-config'] = function()
        dv.close()
      end
    end,
    keys = {
      {
        ',df',
        function()
          require('dap').continue()
        end,
        desc = 'Debug File',
      },
      {
        ',dso',
        "<cmd>lua require('dap').step_over()<cr>",
        desc = 'Debug step over',
      },
      {
        ',dsO',
        "<cmd>lua require('dap').step_out()<cr>",
        desc = 'Debug step out',
      },
      {
        ',dsi',
        "<cmd>lua require('dap').step_into()<cr>",
        desc = 'Debug step into',
      },
      {
        ',dc',
        "<cmd>lua require('dap').continue()<cr>",
        desc = 'Debug continue',
      },
      {
        ',dt',
        "<cmd>lua require('dap').terminate()<cr>",
        desc = 'Debug terminate',
      },
      -- {
      --   ',bb',
      --   "<cmd>lua require('dap').toggle_breakpoint()<cr>",
      --   desc = 'Debug add breakpoint',
      -- },
    },
  },
}
