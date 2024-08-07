return {
  {
    'rmagatti/auto-session',
    dependencies = { 'nvim-tree/nvim-tree.lua' },
    enabled = false,
    opts = {
      log_level = 'error',
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      auto_session_use_git_branch = true,
      session_lens = {
        load_on_setup = false,
      },
      pre_save_cmds = {
        "lua require('user.util.windows').close_tmp_buffers()",
        "lua require('user.util.windows').close_all_nvim_tree_buffers()",
        "lua require('incline').disable()",
      },
    },
    lazy = false,
  },

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
          if vim.g.started_with_stdin == 1 then
            -- Do nothing when started with `nvim -`
            return
          end

          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            resession.load(get_session_name(), { silence_errors = true })
          end
        end,
      })
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          -- prevent autosave when deleting the session
          if not vim.g.delete_current_session then
            require('user.util.windows').close_all_nvim_tree_buffers()
            require('user.util.windows').close_tmp_buffers()
            require('incline').disable()

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
