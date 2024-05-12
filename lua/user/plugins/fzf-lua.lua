return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    -- dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local actions = require 'fzf-lua.actions'
      require('fzf-lua').setup {
        { 'fzf-native' },
        defaults = {
          formatter = 'path.filename_first',
        },
        winopts = {
          -- fullscreen = true,
          width = 0.9,
          height = 0.9,

          preview = {
            -- vertical = 'down:45%', -- up|down:size
            horizontal = 'right:45%', -- right|left:size
          },
        },
        actions = {
          files = {
            ['default'] = actions.file_edit_or_qf,
            ['ctrl-t'] = actions.file_tabedit,
            ['alt-q'] = actions.file_sel_to_qf,
            ['ctrl-s'] = actions.file_split,
            ['ctrl-x'] = actions.file_split,
            ['ctrl-h'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            -- ['ctrl-l'] = actions.file_sel_to_ll,
          },
        },
        keymap = {
          -- builtin = {
          --   -- ['ctrl-d'] = 'preview-page-down',
          --   -- ['ctrl-u'] = 'preview-page-up',
          -- },
          fzf = {
            -- send all to quickfix list
            ['ctrl-q'] = 'select-all+accept',
            ['ctrl-p'] = 'toggle-preview',
            ['ctrl-l'] = 'toggle-preview-wrap',
            ['ctrl-d'] = 'preview-page-down',
            ['ctrl-u'] = 'preview-page-up',
          },
        },
        grep = {
          actions = {
            ['ctrl-g'] = false,
            ['ctrl-f'] = { actions.grep_lgrep },
          },
        },
      }
    end,
    keys = {
      { '<leader>fw', '<cmd>FzfLua live_grep<cr>', desc = 'Grep Text' },
    },
  },
}
