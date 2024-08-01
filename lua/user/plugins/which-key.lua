return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 550
    end,
    opts = {
      -- notify = false,
      spec = {
        { ']', group = 'next' },
        { '[', group = 'prev' },
        { '<leader>g', group = 'goto' },
        { '<leader>c', group = 'close' },
        { '<leader>a', group = 'ai' },
        { '<leader>l', group = 'lsp' },
        { '<leader>f', group = 'find' },
        { '<leader>g', group = 'git' },
        { '<leader>q', group = 'quit' },
        { '<leader>s', group = 'split' },
        { '<leader>t', group = 'toggle' },
        { '<leader>d', group = 'debug' },
        { ',b', group = 'breakpoints' },
        { ',t', group = 'test' },
        { ',o', group = 'other' },
        { ',r', group = 'run' },
        { ',c', group = 'curl' },
      },
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = true,
      },
      icons = {
        rules = false,
      },
      -- modes = { x = false },
    },
  },
}
