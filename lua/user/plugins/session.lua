return {
  {
    'rmagatti/auto-session',
    dependencies = { 'nvim-tree/nvim-tree.lua' },
    enabled = true,
    opts = {
      log_level = 'error',
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      auto_session_use_git_branch = true,
      session_lens = {
        load_on_setup = false,
      },
      pre_save_cmds = {
        "lua require('user.util.windows').close_all_floating_wins()",
        "lua require('user.util.windows').close_all_nvim_tree_buffers()",
      },
    },
    lazy = false,
  },
}
