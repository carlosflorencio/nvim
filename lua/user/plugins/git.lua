return {
  {
    -- generate github links
    'ruifm/gitlinker.nvim',
    -- event = "BufRead",
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitlinker').setup {
        opts = {
          add_current_line_on_normal_mode = true,
          action_callback = require('gitlinker.actions').open_in_browser,
          print_url = true,
          mappings = nil,
        },
        callbacks = {
          ['github-nbcu.com'] = function(url_data)
            url_data.host = 'github.com'

            if url_data.repo:find '/bff' then
              url_data.rev = 'master'
            end

            return require('gitlinker.hosts').get_github_type_url(url_data)
          end,
        },
      }
    end,
    keys = {
      {
        '<leader>gy',
        function()
          require('gitlinker').get_buf_range_url 'n'
        end,
        desc = 'Create github link',
      },
      {
        '<leader>gy',
        function()
          require('gitlinker').get_buf_range_url 'v'
        end,
        mode = 'v',
        desc = 'Create github link',
      },
    },
  },

  {
    'kdheepak/lazygit.nvim',
    enabled = false,
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>' },
      { '<leader>gf', '<cmd>LazyGitFilterCurrentFile<cr>' },
    },
    init = function()
      -- full screen: 1
      vim.g.lazygit_floating_window_scaling_factor = 0.9
    end,
  },

  {
    -- TODO: fix this is making nvim slow when opening the first time
    -- plus lazygit is slow staging files
    'lewis6991/gitsigns.nvim',
    enabled = true,
    -- event = { 'BufReadPre', 'BufNewFile' },
    event = { 'VeryLazy' },
    opts = function()
      return {
        signs = {
          add = { text = '▏' },
          change = { text = '▏' },
          delete = { text = '󰐊' },
          topdelete = { text = '󰐊' },
          changedelete = { text = '▏' },
        },
        -- required to avoid slowdown in lazygit, etc
        update_debounce = 500,
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
          end

          map('n', ']c', gs.next_hunk, 'Next Hunk')
          map('n', '[c', gs.prev_hunk, 'Prev Hunk')
          map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
          map({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
          map('n', '<leader>gS', gs.stage_buffer, 'Stage Buffer')
          map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo Stage Hunk')
          map('n', '<leader>gR', gs.reset_buffer, 'Reset Buffer')
          map('n', '<leader>gp', gs.preview_hunk, 'Preview Hunk')
          map('n', '<leader>gb', function()
            gs.blame_line { full = true }
          end, 'Blame Line')
          map('n', '<leader>gd', function()
            local base_branch = require('user.util.git').get_base_branch()
            gs.change_base(base_branch)

            -- save cursor pos
            local win = vim.api.nvim_get_current_win()
            local buf = vim.api.nvim_get_current_buf()
            local pos = vim.api.nvim_win_get_cursor(win)

            vim.defer_fn(function()
              gs.setqflist()

              -- restore cursor
              vim.schedule(function()
                vim.api.nvim_set_current_win(win) -- Switch back to original window
                vim.api.nvim_win_set_cursor(win, pos)
                vim.api.nvim_set_current_buf(buf) -- ensure buffer is also correct
              end)
            end, 100)
          end, 'Diff This')
          -- map('n', '<leader>gD', function()
          --   gs.diffthis '~'
          -- end, 'Diff This ~')
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
        end,
      }
    end,
  },

  {
    'FabijanZulj/blame.nvim',
    lazy = true,
    config = function()
      require('blame').setup()
    end,
    keys = {
      { '<leader>gB', '<cmd>BlameToggle virtual<cr>', desc = 'Blame Toggle' },
    },
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewFileHistory', 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    opts = {
      use_icons = false,
      -- reduce deletions bright colors
      enhanced_diff_hl = true,
      view = {
        file_history = {
          layout = 'diff2_horizontal',
          winbar_info = false,
        },
      },
      hooks = {
        view_opened = function()
          -- require('diffview.actions').toggle_files()
        end,
        diff_buf_win_enter = function()
          vim.opt_local.foldenable = false
        end,
      },
    },
    keys = {
      -- imply-local allows to use LSP on the right side
      { ',HH', '<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>', desc = 'Git compare against master (review)', mode = 'n' },
      { ',hh', '<cmd>DiffviewFileHistory --follow %<cr>', desc = 'Git File History', mode = 'n' },
      { ',hh', "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = 'Git History', mode = 'v' },
      { ',hc', '<cmd>DiffviewClose<cr>', desc = 'Diffview Close' },
    },
  },

  {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = 'VeryLazy',
    config = true,
    opts = {
      default_mappings = false,
      disable_diagnostics = true,
    },
    lazy = false,
    keys = {
      {
        '<leader>gC',
        '<cmd>GitConflictListQf<cr>',
        desc = 'Open git conflict list',
      },
      {
        '<leader>gc',
        function()
          vim.ui.select({
            'Ours (Current)',
            'Theirs (Incoming)',
            'Both',
            'None',
          }, {
            prompt = 'Git Conflict',
            format_item = function(item)
              return 'Choose ' .. item
            end,
            kind = 'custom_builtin',
          }, function(_, idx)
            if idx == nil then
              return
            end

            local cmds = {
              'GitConflictChooseOurs',
              'GitConflictChooseTheirs',
              'GitConflictChooseBoth',
              'GitConflictChooseNone',
            }

            vim.cmd(cmds[idx])
          end)
        end,
        desc = 'Git conflict resolve',
      },
      {
        ']x',
        '<Plug>(git-conflict-next-conflict)',
        desc = 'Git conflict: Go to next',
      },
      {
        '[x',
        '<Plug>(git-conflict-prev-conflict)',
        desc = 'Git conflict: Go to prev',
      },
    },
  },
}
