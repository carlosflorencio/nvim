return {
  {
    'stevearc/resession.nvim',
    enabled = true,
    config = function()
      local resession = require 'resession'

      resession.setup {
        autosave = {
          enabled = true,
          interval = 120,
          notify = false,
        },

        options = {
          'binary',
          -- 'bufhidden',
          -- 'buflisted',
          'cmdheight',
          'diff',
          'filetype',
          'modifiable',
          'previewwindow',
          'readonly',
          'scrollbind',
          'winfixheight',
          'winfixwidth',
          'shiftwidth', -- added from here
          'tabstop',
        },

        -- disable quickfix extension
        extensions = {},
      }

      local function get_session_name()
        local name = vim.fn.getcwd()
        local branch = vim.trim(vim.fn.system 'git branch --show-current')
        if vim.v.shell_error == 0 then
          return name .. branch
        else
          return name
        end
      end

      vim.g.delete_current_session = false

      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          -- Do nothing when started with arguments
          -- default argv is {"nvim", "--embed"}
          if #vim.v.argv > 2 then
            -- nvim -c "Oil"
            -- nvim - (stdin
            return
          end

          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            local name = get_session_name()
            resession.load(name, { silence_errors = true })
          end
        end,
        nested = true,
      })
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          -- tmp repo clones
          if vim.fn.getcwd():find 'git%-dev' then
            return
          end

          -- prevent autosave when deleting the session
          if not vim.g.delete_current_session then
            require('user.util.windows').close_all_nvim_tree_buffers()
            require('user.util.windows').close_tmp_buffers()
            require('incline').disable()
            -- discard quickfix list
            vim.cmd 'cexpr[]'
            vim.cmd 'cclose'

            resession.save(get_session_name(), { notify = false })
          end
        end,
      })

      vim.api.nvim_create_user_command('SessionDelete', function()
        resession.delete(get_session_name())
        vim.g.delete_current_session = true
      end, {
        desc = 'Delete Current Session',
      })
    end,
  },
}
