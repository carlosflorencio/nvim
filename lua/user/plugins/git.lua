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
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>' },
    },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 1
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = function()
      return {
        signs = {
          add = { text = '▏' },
          change = { text = '▏' },
          delete = { text = '󰐊' },
          topdelete = { text = '󰐊' },
          changedelete = { text = '▏' },
        },
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
          map('n', '<leader>gd', gs.diffthis, 'Diff This')
          map('n', '<leader>ghD', function()
            gs.diffthis '~'
          end, 'Diff This ~')
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
        end,
      }
    end,
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewFileHistory', 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    keys = {
      { ',HH', '<cmd>DiffviewFileHistory<cr>', desc = 'Git Repo History', mode = 'n' },
      { ',hh', '<cmd>DiffviewFileHistory --follow %<cr>', desc = 'Git File History', mode = 'n' },
      { ',hh', "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", desc = 'Git History', mode = 'v' },
      { ',hc', '<cmd>DiffviewClose<cr>', desc = 'Diffview Close' },
    },
  },

  {
    'akinsho/git-conflict.nvim',
    version = '*',
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
