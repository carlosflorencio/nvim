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
      extra_domain_to_parser = {
        ['github.com'] = function(parser, text, _)
          local function transform(url, branch)
            local result = parser:parse_github_url(url, 'github.com')

            if result.repo_url then
              if result.repo_url:lower():find 'nbcudtc' then
                -- switch to ssh to use a different user
                result.repo_url = result.repo_url:gsub('https://', 'git@')
                result.repo_url = result.repo_url:gsub('github.com/', 'github.com-nbcu:')

                if result.full_blob then
                  -- todo: parse branch and file path
                  result.full_blob = nil
                end
                result.type = 'ssh'
              end
            end

            return result
          end

          -- if text:find '/pull/' then
          --   require('user.util.github').fetch_pr_branch(text, function(branch, error)
          --     print('here[13]: git-dev.lua:48: error=' .. vim.inspect(error))
          --     print('here[12]: git-dev.lua:48: branch=' .. vim.inspect(branch))
          --     if error then
          --       print('Failed to fetch PR branch: ' .. error)
          --       return transform(text)
          --     end

          --     return transform(text, branch)
          --   end)
          -- else
          return transform(text)
          -- end
        end,
      },
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
