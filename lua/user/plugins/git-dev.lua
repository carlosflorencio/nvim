return {
  {
    'moyiz/git-dev.nvim',
    -- event = 'VeryLazy',
    lazy = true,
    cmd = { 'GitDevOpen', 'GitDevCleanAll' },
    opts = {
      ephemeral = false,
      read_only = false,
      -- ~/.cache/nvim/git-dev
      repositories_dir = vim.fn.stdpath 'cache' .. '/git-dev',
      -- open new repos in new tab and set cwd in that tab
      cd_type = 'tab',
      opener = function(dir, _, selected_path)
        vim.cmd 'tabnew'
        vim.cmd('Oil ' .. vim.fn.fnameescape(dir))
        if selected_path then
          vim.cmd('edit ' .. selected_path)
        end
      end,
    },
    keys = {
      {
        '<leader>og',
        function()
          local repo = vim.fn.input 'Repository name / URI: '
          if repo ~= '' then
            require('git-dev').open(repo)
          end
        end,
        desc = 'Open a Git Repository',
      },
    },
  },
}
