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
}
