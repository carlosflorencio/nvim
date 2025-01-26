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

      local oil_get_selected_folder = function()
        local o = require 'oil'
        local e = o.get_entry_on_line(0, vim.fn.line '.')
        if e == nil then
          vim.api.nvim_err_writeln 'No oil file found'
          return nil
        end
        if e.type ~= 'directory' then
          return nil
        end

        local current_dir = o.get_current_dir()
        return current_dir .. e.name
      end

      require('oil').setup {
        default_file_explorer = true,
        -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
        skip_confirm_for_simple_edits = true,

        lsp_file_methods = {
          -- Set to true to autosave buffers that are updated with LSP willRenameFiles
          -- Set to "unmodified" to only save unmodified buffers
          autosave_changes = true,
        },

        view_options = {
          show_hidden = true,
        },

        -- git signs
        win_options = {
          signcolumn = 'yes:2',
        },

        use_default_keymaps = false,
        delete_to_trash = true,
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['l'] = 'actions.select',
          ['<C-v>'] = select_close { vertical = true },
          ['<C-x>'] = select_close { horizontal = true },
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
          ['fw'] = function()
            local path = oil_get_selected_folder()
            -- require('telescope.builtin').live_grep { cwd = path }
            Snacks.picker.grep { cwd = path }
          end,
        },
      }
    end,
    -- dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>;', '<cmd>Oil<cr>', desc = 'Oil' },
      { '<c-;>', '<cmd>Oil<cr>', desc = 'Oil' },
    },
  },

  {
    'refractalize/oil-git-status.nvim',
    enabled = true,
    dependencies = {
      'stevearc/oil.nvim',
    },
    opts = {
      -- ignore ../
      show_ignored = false,
    },
  },
}
