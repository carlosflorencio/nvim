return {
  {
    -- preview markdown, glow needs to be installed globally
    'npxbr/glow.nvim',
    enabled = false,
    ft = { 'markdown' },
    opts = {
      width_ratio = 0.8, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
      height_ratio = 0.8,
    },
    keys = {
      { '<leader>pp', '<cmd>Glow<cr>', desc = 'Glow Markdown Preview' },
    },
  },

  {
    'mrjones2014/mdpreview.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'Mdpreview' },
    -- ft = 'markdown', -- you can lazy load on markdown files only
    -- requires the `terminalk filetype to render ASCII color and format codes
    dependencies = { 'norcalli/nvim-terminal.lua', config = true },
    config = function()
      require('mdpreview').setup {
        renderer = {
          opts = {
            win_opts = {
              wrap = false,
            },
          },
        },
      }
    end,
    keys = {
      {
        '<leader>pp',
        '<cmd>Mdpreview<cr>',
        desc = 'Glow Markdown Preview',
      },
    },
  },

  {
    -- <c-space> turn list item into todo
    -- :MkdnTable 2 2, :MkdnTableFormat
    --
    -- <c-t> increase indentation
    -- <c-d> decrease indentation
    'jakewvincent/mkdnflow.nvim',
    enabled = true,
    ft = { 'markdown' },
    config = function()
      require('mkdnflow').setup {
        mappings = {
          -- MkdnNewListItem = { "i", "<CR>" },
          MkdnEnter = { { 'i', 'n', 'v' }, '<CR>' },
          MkdnFoldSection = { 'n', '<leader>z' },
          MkdnUnfoldSection = { 'n', '<leader>Z' },
          MkdnTableNewRowBelow = { 'n', '<leader>nr' },
          MkdnTableNewRowAbove = { 'n', '<leader>nR' },
          MkdnTableNewColAfter = { 'n', '<leader>nc' },
          MkdnTableNewColBefore = { 'n', '<leader>nC' },
        },
        table = {
          auto_extend_rows = true,
        },
      }
    end,
  },

  {
    -- Render markdown in normal mode
    'MeanderingProgrammer/markdown.nvim',
    ft = { 'markdown' },
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup {}
    end,
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
