return {
  {
    -- preview markdown, glow needs to be installed globally
    'npxbr/glow.nvim',
    enabled = false,
    ft = { 'markdown' },
    opts = {
      width_ratio = 0.8, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
      height_ratio = 0.8,
    },
    keys = {
      { '<leader>pp', '<cmd>Glow<cr>', desc = 'Glow Markdown Preview' },
    },
  },

  {
    'mrjones2014/mdpreview.nvim',
    lazy = true,
    -- ft = 'markdown', -- you can lazy load on markdown files only
    -- requires the `terminalk filetype to render ASCII color and format codes
    dependencies = { 'norcalli/nvim-terminal.lua', config = true },
    config = function()
      require('mdpreview').setup {}
    end,
    keys = {
      {
        '<leader>pp',
        function()
          require('mdpreview').preview {
            backend = 'buffer',
            opts = {
              win_opts = {
                wrap = false,
              },
            },
          }
        end,
        desc = 'Glow Markdown Preview',
      },
    },
  },

  {
    -- <c-space> turn list item into todo
    -- :MkdnTable 2 2, :MkdnTableFormat
    --
    -- <c-t> increase indentation
    -- <c-d> decrease indentation
    'jakewvincent/mkdnflow.nvim',
    ft = { 'markdown' },
    config = function()
      require('mkdnflow').setup {
        mappings = {
          -- MkdnNewListItem = { "i", "<CR>" },
          MkdnEnter = { { 'i', 'n', 'v' }, '<CR>' },
          MkdnFoldSection = { 'n', '<leader>z' },
          MkdnUnfoldSection = { 'n', '<leader>Z' },
          MkdnTableNewRowBelow = { 'n', '<leader>nr' },
          MkdnTableNewRowAbove = { 'n', '<leader>nR' },
          MkdnTableNewColAfter = { 'n', '<leader>nc' },
          MkdnTableNewColBefore = { 'n', '<leader>nC' },
        },
        table = {
          auto_extend_rows = true,
        },
      }
    end,
  },
}
