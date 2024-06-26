return {
  {
    -- package.json update actions, <leader>pv to change version
    'vuki656/package-info.nvim',
    dependencies = 'MunifTanjim/nui.nvim',
    ft = 'json',
    opts = {
      hide_up_to_date = true,
      hide_unstable_versions = true,
      colors = {
        -- up_to_date = '#3C4048', -- Text color for up to date dependency virtual text
        -- outdated = '#d19a66', -- Text color for outdated dependency virtual text
      },
    },
    keys = {
      {
        '<leader>pv',
        "<cmd>lua require('package-info').change_version()<cr>",
        desc = 'Package.json Change Version Dep',
      },
    },
  },

  {
    'dmmulroy/tsc.nvim',
    cmd = { 'TSC', 'TSCStop' },
    opts = {
      use_diagnostics = false,
      auto_close_qflist = true,
      flags = {
        watch = true,
      },
      -- enable_progress_notifications = false,
    },
    keys = {
      {
        ',tc',
        '<cmd>TSC<cr>',
        desc = 'TS Type Check Compile',
      },

      {
        ',ts',
        '<cmd>TSCStop<cr>',
        desc = 'TS Type Check Stop',
      },
    },
  },
}
