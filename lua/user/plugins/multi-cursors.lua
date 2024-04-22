return {
  {
    -- multi cursor a like, cmd - d
    'smoka7/multicursors.nvim',
    enabled = true,
    dependencies = {
      'smoka7/hydra.nvim',
    },
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<f13>l',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },

  {
    'brenton-leighton/multiple-cursors.nvim',
    version = '*', -- Use the latest tagged version
    opts = {
      pre_hook = function()
        -- require('nvim-autopairs').disable()
      end,

      post_hook = function()
        -- require('nvim-autopairs').enable()
      end,
    },
    config = function(_, opts)
      require('multiple-cursors').setup(opts)
    end,
    keys = {
      { '<F13>j', '<Cmd>MultipleCursorsAddDown<CR>', mode = { 'n', 'i' } },
      { '<F13>k', '<Cmd>MultipleCursorsAddUp<CR>', mode = { 'n', 'i' } },
      -- { '<F13>l', '<Cmd>MultipleCursorsAddMatches<CR>', mode = { 'n', 'x' } },
    },
  },
}
