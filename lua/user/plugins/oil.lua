return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    config = function()
      -- Helper function to close the oil buffer after a selection.
      ---@param select_opts table options to pass to `oil.select`
      ---@return function #function to invoke the action
      local function select_close(select_opts)
        local opts = vim.tbl_extend('keep', { close = true }, select_opts)
        return function()
          require('oil').select(opts)
        end
      end

      require('oil').setup {
        -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
        skip_confirm_for_simple_edits = true,

        -- use_default_keymaps = false,
        delete_to_trash = true,
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['l'] = 'actions.select',
          ['<C-v>'] = select_close { vertical = true },
          ['<C-h>'] = select_close { horizontal = true },
          ['<C-t>'] = select_close { tab = true },
          ['<C-p>'] = 'actions.preview',
          ['q'] = 'actions.close',
          ['<esc>'] = 'actions.close',
          -- ['<C-l>'] = 'actions.refresh',
          ['h'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['I'] = 'actions.toggle_hidden',
        },
      }
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>;', '<cmd>Oil<cr>', desc = 'Oil' },
    },
  },
}
