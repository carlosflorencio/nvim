return {
  {
    -- floating notes
    'JellyApple102/flote.nvim',
    lazy = true,
    config = function()
      require('flote').setup {
        window_border = 'single',
        window_style = 'minimal',
        window_title = true,
        notes_dir = vim.g.personal_notes .. '/Projects',
        files = {
          global = 'global.md',
          cwd = function()
            local bufPath = vim.api.nvim_buf_get_name(0)
            local cwd = require('lspconfig').util.root_pattern '.git'(bufPath)

            vim.notify(cwd)
            return cwd
          end,
        },
      }
    end,
    keys = {
      { '<leader>pn', '<cmd>Flote<CR>', desc = 'Project Notes' },
    },
  },

  {
    -- Journal day, week, month, year, quarter
    -- Journal next, Journal -2
    'jakobkhansen/journal.nvim',
    cmd = { 'Journal' },
    config = function()
      require('journal').setup {
        root = vim.g.personal_notes .. '/Journal',
        journal = {
          -- Default configuration for `:Journal <date-modifier>`
          format = '%Y/%m %B/%d %A',
          template = '# %A %B %d %Y\n\n## Work\n\n## Personal\n\n',
          -- Nested configurations for `:Journal <type> <type> ... <date-modifier>`
          entries = {
            day = {
              format = '%Y/%m %B/%d - %A', -- Format of the journal entry in the filesystem.
              template = '# %A %B %d %Y\n\n## Work\n\n## Personal\n\n',
              frequency = { day = 1 }, -- Optional. The frequency of the journal entry. Used for `:Journal next`, `:Journal -2` etc
            },
            week = {
              format = '%Y/%m %B/week %W',
              template = '# Week %W %B %Y\n',
              frequency = { day = 7 },
              date_modifier = 'monday', -- Optional. Date modifier applied before other modifier given to `:Journal`
            },
            month = {
              format = '%Y/%m %B/%B',
              template = '# %B %Y\n',
              frequency = { month = 1 },
            },
            year = {
              format = '%Y/%Y',
              template = '# %Y\n',
              frequency = { year = 1 },
            },
            quarter = {
              -- strftime doesn't supply a quarter variable, so we compute it manually
              format = function(date)
                local quarter = math.ceil(tonumber(os.date('%m', os.time(date.date))) / 3)
                return '%Y/quarter/' .. quarter
              end,
              template = function(date)
                local quarter = math.ceil(os.date('%m', os.time(date.date)) / 3)
                return '# %Y Quarter ' .. quarter .. '\n'
              end,
              frequency = { month = 3 },
            },
          },
        },
      }
    end,
    keys = {
      { '<leader>oj', '<cmd>Journal<cr>', desc = 'Journal Day' },
    },
  },
}
