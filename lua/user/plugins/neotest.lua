return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'fredrikaverpil/neotest-golang',
        version = '*',
        opts = {}
      },
    },
    config = function()
      local neotest_golang_opts = {
        warn_test_name_dupes = false
      } -- Specify custom configuration
      require('neotest').setup {
        adapters = {
          require 'neotest-golang' (neotest_golang_opts), -- Registration
        },
      }
    end,
    keys = {
      {
        ',tu',
        function()
          require('neotest').run.run()
        end,
        desc = 'Run nearest test under cursor',
      },
      {
        ',tf',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Test file',
      },
      {
        ',td',
        function()
          require('neotest').run.run {
            strategy = 'dap',
          }
        end,
        desc = 'Debug nearest test under cursor',
      },
      { ',to', '<cmd>lua require("neotest").output.open()<cr>',            desc = 'Test Output' },
      { ',tp', '<cmd>lua require("neotest").output_panel.toggle()<cr>',    desc = 'Test Output Panel' },
      { ',ts', '<cmd>lua require("neotest").summary.toggle()<cr>',         desc = 'Toggle Test Summary' },
      { ',ta', '<cmd>lua require("neotest").run.run(vim.fn.getcwd())<cr>', desc = 'Run tests in current directory' },
    },
  },
}
