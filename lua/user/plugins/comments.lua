return {
  -- comments
  { 'JoosepAlviste/nvim-ts-context-commentstring' },
  {
    'numToStr/Comment.nvim',
    opts = {
      ignore = '^$',
      -- tsx/jsx support
      pre_hook = function(...)
        local loaded, ts_comment = pcall(require, 'ts_context_commentstring.integrations.comment_nvim')
        if loaded and ts_comment then
          return ts_comment.create_pre_hook()(...)
        end
      end,
    },
    keys = {
      { 'gc', mode = { 'n', 'v' } },
      { 'gb', mode = { 'n', 'v' } },
      { '<leader>/', '<Plug>(comment_toggle_linewise_visual)', desc = 'Comment toggle linewise (visual)', mode = 'v' },
      { '<leader>/', '<Plug>(comment_toggle_linewise_current)', desc = 'Comment toggle current line' },
    },
    event = 'User FileOpened',
  },

  {
    'folke/todo-comments.nvim',
    event = 'BufRead',
    opts = {},
  },
}
