return {
  {
    'gbprod/substitute.nvim',
    dependencies = {
      'gbprod/yanky.nvim',
    },
    opts = {
      on_substitute = function()
        require('yanky.integration').substitute()
      end,
      highlight_substituted_text = {
        enabled = false,
      },
    },
    keys = {
      {
        'r',
        function()
          require('substitute').operator()
        end,
        desc = 'Substitute',
        mode = { 'n' },
      },
      {
        'rr',
        function()
          require('substitute').line()
        end,
        desc = 'Substitute line',
        mode = { 'n' },
      },
      {
        'R',
        function()
          require('substitute').eol()
        end,
        desc = 'Substitute eol',
        mode = { 'n' },
      },
      {
        'r',
        function()
          require('substitute').visual()
        end,
        desc = 'Substitute visual',
        mode = { 'x' },
      },
    },
  },
}
