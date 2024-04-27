return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      {
        -- frecency algorithm for sorting results
        'danielfalk/smart-open.nvim',
        branch = '0.2.x',
        dependencies = {
          'kkharji/sqlite.lua',
          {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
          },
        },
        opts = {
          result_limit = 50,
        },
      },
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
      {
        'ahmedkhalf/project.nvim',
        config = function()
          require('project_nvim').setup()
        end,
      },
    },
    config = function()
      local actions = require 'telescope.actions'
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          file_ignore_patterns = { 'node_modules', '.git', 'pnpm-lock.yaml' },
          preview = {
            filesize_limit = 0.5,
            timeout = 100,
          },
          mappings = {
            n = {
              ['<C-Esc>'] = require('telescope.actions').to_fuzzy_refine,
            },
            i = {
              ['<C-Esc>'] = require('telescope.actions').to_fuzzy_refine,

              -- search B after searching for A
              ['<C-r>'] = {
                function(p_bufnr)
                  -- send results to quick fix list
                  require('telescope.actions').send_to_qflist(p_bufnr)
                  local qflist = vim.fn.getqflist()
                  local paths = {}
                  local hash = {}
                  for k in pairs(qflist) do
                    local path = vim.fn.bufname(qflist[k]['bufnr']) -- extract path from quick fix list
                    if not hash[path] then -- add to paths table, if not already appeared
                      paths[#paths + 1] = path
                      hash[path] = true -- remember existing paths
                    end
                  end

                  -- show search scope with message
                  -- execute live_grep_args with search scope
                  require('telescope').extensions.live_grep_args.live_grep_args { search_dirs = paths }
                end,
                type = 'action',
                opts = {
                  nowait = true,
                  silent = true,
                  desc = 'Live grep on results',
                },
              },
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            -- @usage don't include the filename in the search results
            only_sort_text = true,
            additional_args = { '--hidden' },
          },
          buffers = {
            initial_mode = 'normal',
            theme = 'dropdown',
            layout_config = {
              width = 0.6, -- Adjust as needed
            },
            mappings = {
              i = {
                ['<C-d>'] = actions.delete_buffer,
              },
              n = {
                ['dd'] = actions.delete_buffer,
              },
            },
          },
          git_files = {
            hidden = true,
            show_untracked = true,
          },
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {
              -- extend mappings
              i = {
                ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
                ['<C-t>'] = require('telescope-live-grep-args.actions').quote_prompt { postfix = "-g '!pnpm-lock.yaml' -t " },
                ['<C-f>'] = require('telescope-live-grep-args.actions').quote_prompt {
                  postfix = " -g '!**/node_modules/**' -g '!pnpm-lock.yaml' -g **/**/**",
                },
              },
            },
          },
          smart_open = {
            ignore_patterns = { '*.git/*', '*/tmp/*', '*/dist/*' },
            match_algorithm = 'fzf',
          },
          undo = {
            side_by_side = true,
            layout_strategy = 'vertical',
            layout_config = {
              preview_height = 0.6,
            },
            mappings = {
              i = {
                ['<cr>'] = require('telescope-undo.actions').yank_additions,
                ['<S-cr>'] = require('telescope-undo.actions').yank_deletions,
                ['<C-cr>'] = require('telescope-undo.actions').restore,
                -- alternative defaults, for users whose terminals do questionable things with modified <cr>
                ['<C-y>'] = require('telescope-undo.actions').yank_deletions,
                ['<C-r>'] = require('telescope-undo.actions').restore,
              },
              n = {
                ['y'] = require('telescope-undo.actions').yank_additions,
                ['Y'] = require('telescope-undo.actions').yank_deletions,
                ['u'] = require('telescope-undo.actions').restore,
                ['<cr>'] = require('telescope-undo.actions').yank_additions,
                ['<S-cr>'] = require('telescope-undo.actions').yank_deletions,
              },
            },
          },
        },
      }

      telescope.load_extension 'fzf'
      telescope.load_extension 'smart_open'
      telescope.load_extension 'undo'
      telescope.load_extension 'live_grep_args'
      telescope.load_extension 'projects'
    end,
    keys = {
      {
        '<leader>fb',
        '<cmd>Telescope git_branches initial_mode=normal<cr>',
        desc = 'Checkout Branch',
      },
      {
        '<leader>j',
        '<cmd>Telescope buffers show_all_buffers=true previewer=false ignore_current_buffer=true sort_mru=true<cr>',
        desc = 'Open Buffers',
      },
      { '<leader>tt', '<cmd>Telescope diagnostics initial_mode=normal<cr>', desc = 'LSP Diagnostics' },
      {
        '<leader>fg',
        '<cmd>Telescope git_status initial_mode=normal  previewer=false sort_mru=true<cr>',
        desc = 'Git changed files',
      },
      {
        '<leader>fa',
        '<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>',
        desc = 'Find All Files',
      },
      {
        '<leader>ff',
        "<Cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true})<CR>",
        desc = 'Find Project File',
      },
      {
        '<leader>fi',
        '<Cmd>Telescope lsp_dynamic_workspace_symbols<cr>',
        desc = 'Find workspace symbols',
      },
      { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Find Help' },
      { '<leader>fd', '<cmd>Telescope diagnostics initial_mode=normal theme=dropdown<cr>', desc = 'Find diagnostics' },
      { '<leader>fM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
      {
        '<leader>fr',
        '<cmd>Telescope oldfiles initial_mode=normal only_cwd=true<cr>',
        desc = 'Open Recent Files',
      },
      { '<leader>fR', '<cmd>Telescope registers initial_mode=normal<cr>', desc = 'Registers' },
      { '<leader>fW', '<cmd>Telescope live_grep<cr>', desc = 'Grep Text' },
      -- { '<leader>fw', '<cmd>Telescope live_grep_args<cr>', desc = 'Grep Text' },
      { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Keymaps' },
      { '<leader>fc', '<cmd>Telescope commands<cr>', desc = 'Commands' },
      { '<leader>fu', '<cmd>Telescope undo initial_mode=normal<cr>', desc = 'Undo list' },
      {
        '<leader>fT',
        "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
        desc = 'Colorscheme with Preview',
      },
      {
        '<leader>fp',
        '<cmd>Telescope projects<cr>',
        desc = 'Projects',
      },
      {
        '<F13>o',
        '<cmd>Telescope projects<cr>',
        desc = 'Projects',
      },
    },
  },

  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    -- dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local actions = require 'fzf-lua.actions'
      require('fzf-lua').setup {
        { 'fzf-native' },
        actions = {
          files = {
            ['default'] = actions.file_edit_or_qf,
            ['ctrl-t'] = actions.file_tabedit,
            ['alt-q'] = actions.file_sel_to_qf,
            ['ctrl-s'] = actions.file_split,
            ['ctrl-h'] = actions.file_split,
            ['ctrl-v'] = actions.file_vsplit,
            ['ctrl-l'] = actions.file_sel_to_ll,
          },
        },
        keymap = {
          builtin = {
            ['<c-d>'] = 'preview-page-down',
            ['<c-u>'] = 'preview-page-up',
          },
          fzf = {
            -- send all to quickfix list
            ['ctrl-q'] = 'select-all+accept',
          },
        },
        grep = {
          actions = {
            ['ctrl-g'] = false,
            ['ctrl-f'] = { actions.grep_lgrep },
          },
        },
      }
    end,
    keys = {
      { '<leader>fw', '<cmd>FzfLua live_grep<cr>', desc = 'Grep Text' },
    },
  },
}
