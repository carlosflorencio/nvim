return {
  {
    'oysandvik94/curl.nvim',
    cmd = { 'CurlOpen' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('curl').setup()
    end,
    keys = {
      {
        ',c',
        function()
          require('curl').execute_curl()
        end,
        { desc = 'Run curl' },
      },
    },
  },
}
