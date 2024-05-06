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
    config = function()
      local resession = require 'resession'

      resession.setup {
        autosave = {
          enabled = true,
          interval = 120,
          notify = false,
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

      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            resession.load(get_session_name(), { dir = 'dirsession', silence_errors = true })
          end
        end,
      })
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          resession.save(get_session_name(), { dir = 'dirsession', notify = false })
        end,
      })
    end,
  },
}
