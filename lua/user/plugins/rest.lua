return {
  {
    'oysandvik94/curl.nvim',
    cmd = { 'CurlOpen' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = true,
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
