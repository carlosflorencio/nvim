return {

  { 'tpope/vim-repeat', event = 'VeryLazy' },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    enabled = true,
    opts = {
      label = {
        -- uppercase = false,
        exclude = 'S',
      },
      jump = {
        -- automatically jump when there is only one match
        autojump = true,
      },
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = true,
          keys = { 'f', 'F', ';', ',' },
          label = { exclude = 'hjkliardco' },
        },
      },
    },
        -- stylua: ignore
        keys = {
                { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
                { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
                { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
                { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        }
,
  },

  {
    -- expand <C-a>/<C-x> toggles increments
    'nat-418/boole.nvim',
    opts = {
      mappings = {
        increment = '<C-a>',
        decrement = '<C-x>',
      },
    },
    event = 'VeryLazy',
  },

  {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    config = function()
      local ts_node_action = require 'ts-node-action'
      ts_node_action.setup {
        tsx = ts_node_action.node_actions.typescriptreact,
      }
    end,
    keys = {
      {
        '<leader>ss',
        '<cmd>lua require("ts-node-action").node_action()<cr>',
        desc = 'Toggle node action under cursor',
      },
    },
  },
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter-textobjects' },
    opts = function()
      local ai = require 'mini.ai'
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
          -- line
          L = function(ai_type)
            local line_num = vim.fn.line '.'
            local line = vim.fn.getline(line_num)
            -- Select `\n` past the line for `a` to delete it whole
            local from_col, to_col = 1, line:len() + 1
            if ai_type == 'i' then
              if line:len() == 0 then
                -- Don't remove empty line
                from_col, to_col = 0, 0
              else
                -- Ignore indentation for `i` textobject and don't remove `\n` past the line
                from_col = line:match '^%s*()'
                to_col = line:len()
              end
            end

            return { from = { line = line_num, col = from_col }, to = { line = line_num, col = to_col } }
          end,
          -- buffer
          B = function(ai_type)
            local n_lines = vim.fn.line '$'
            local start_line, end_line = 1, n_lines
            if ai_type == 'i' then
              -- Skip first and last blank lines for `i` textobject
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(1), vim.fn.prevnonblank(n_lines)
              start_line = first_nonblank == 0 and 1 or first_nonblank
              end_line = last_nonblank == 0 and n_lines or last_nonblank
            end

            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end,
        },
      }
    end,
  },

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
    'LunarVim/bigfile.nvim',
    opts = {},
  },
}
