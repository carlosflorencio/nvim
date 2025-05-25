return {
  {
    'MagicDuck/grug-far.nvim',
    lazy = true,
    config = function()
      require('grug-far').setup {
        windowCreationCommand = 'tabnew %',
      }

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('carlos/grugfar', { clear = true }),
        pattern = { 'grug-far' },
        callback = function()
          vim.keymap.set('n', '<localleader>w', function()
            local state = unpack(require('grug-far').get_instance(0):toggle_flags { '--fixed-strings' })
            vim.notify('grug-far: toggled --fixed-strings ' .. (state and 'ON' or 'OFF'))
          end, { buffer = true })
        end,
      })
    end,
    keys = {
      {
        '<leader>sr',
        function()
          require('grug-far').open {
            prefills = {
              search = vim.fn.expand '<cword>',
              filesFilter = vim.fn.expand '%',
            },
          }
        end,
        desc = 'Replace in files (GrugFar)',
      },
    },
  },
  {
    'chrisgrieser/nvim-rip-substitute',
    cmd = 'RipSubstitute',
    keys = {
      {
        '<leader>r',
        function()
          require('rip-substitute').sub()
        end,
        mode = { 'n', 'x', 'v' },
        desc = ' rip substitute (search & replace)',
      },
    },
  },
  {
    -- powerful search & replace
    'windwp/nvim-spectre',
    enabled = false,
    opts = {},
    keys = {
      {
        '<F3>',
        function()
          local path = vim.fn.fnameescape(vim.fn.expand '%:p:.')
          require('spectre').open_visual {
            select_word = true,
            path = path,
          }
        end,
        desc = 'Replace in files (Spectre)',
      },
      {
        '<leader>sr',
        function()
          local path = vim.fn.fnameescape(vim.fn.expand '%:p:.')
          require('spectre').open_visual {
            select_word = true,
            path = path,
          }
        end,
        desc = 'Replace in files (Spectre)',
      },
    },
  },
}
