return {
  {
    'mason-org/mason-lspconfig.nvim',
    event = 'BufReadPost',
    -- enabled = false,
    dependencies = {
      'neovim/nvim-lspconfig',
      'mason-org/mason.nvim',
    },
    opts = {
      ensure_installed = {
        'lua_ls',
        'html',
        'gopls',
        'pyright',
        'rust_analyzer',
        'denols',
        'groovyls',
        'kotlin_language_server',
        'starpls',
        'starlark_rust',
        -- 'kcl',
        'yamlls',
        'jsonls',
        'golangci_lint_ls',
        'ts_ls', -- required by typescript-tools

        -- personal notes lsp
        -- auto completion links [[]]
        'markdown_oxide',
      },
      automatic_installation = true,
      automatic_enable = {
        exclude = { 'ts_ls', 'harper_ls', 'copilot' },
      },
    },
    config = function(_, opts)
      require('mason').setup()
      require('mason-lspconfig').setup(opts)

      -- LSP Capabilities
      -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
      -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
      local capabilities = {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      }

      if package.loaded['nvim-cmp'] then
        capabilities = require('nvim-cmp').default_capabilities(capabilities)
      end

      if package.loaded['blink.cmp'] then
        capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
      end

      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- needs to be installed globally instead of via Mason
      -- https://github.com/kcl-lang/kcl.nvim/issues/18
      vim.lsp.enable("kcl")


      -- diagnostics
      local icons = require('user.icons').lsp_diagnostic_icons
      local updated_diagnostics = {
        underline = false,
        update_in_insert = false,
        -- virtual_text = {
        --   spacing = 1,
        --   prefix = "",
        -- },
        -- virtual_text = {
        --   source = true,
        --   severity = 'ERROR',
        -- },
        virtual_text = false,
        virtual_lines = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = true,
        },

        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.HINT] = icons.Hint,
            [vim.diagnostic.severity.INFO] = icons.Info,
          },
        },
      }
      vim.diagnostic.config(updated_diagnostics)
    end,
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- lazy = false,
    event = 'VeryLazy',
    opts = {
      ensure_installed = {
        -- formatters
        'shfmt',
        'prettierd',
        'mdformat',
        'stylua',
        'isort',
      },
    },
  },

  {
    'b0o/SchemaStore.nvim',
    version = false, -- last release is way too old
  },

  {
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'typescriptreact', 'javascript' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('typescript-tools').setup {
        root_dir = require('lspconfig').util.root_pattern('.git', 'package-lock.json', 'yarn.lock'),
        settings = {
          -- tsserver_file_preferences = {
          --   includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all'
          --   includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          --   includeInlayVariableTypeHints = true,
          --   includeInlayFunctionParameterTypeHints = true,
          --   includeInlayVariableTypeHintsWhenTypeMatchesName = true,
          --   includeInlayPropertyDeclarationTypeHints = true,
          --   includeInlayFunctionLikeReturnTypeHints = true,
          --   includeInlayEnumMemberValueHints = true,
          -- },
        },
      }

      -- vim.lsp.inlay_hint.enable()
    end,
  },

  { -- Autoformat
    -- :ConformInfo for debug
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>fm',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        desc = 'Format buffer',
      },
    },
    config = function()
      require('conform').setup {
        log_level = vim.log.levels.TRACE,
        -- when the file has errors, don't notify
        notify_on_error = true,
        format_on_save = function(bufnr)
          -- Disable autoformat on certain filetypes
          -- local ignore_filetypes = { 'sql', 'java' }
          -- if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          --   return
          -- end

          -- Disable with a global or buffer-local variable
          -- check cmds.lua
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end

          -- Disable autoformat for files in a certain path
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match '/node_modules/' then
            return
          end

          return { timeout_ms = 1000, lsp_fallback = true }
        end,
        formatters_by_ft = {
          -- go install golang.org/x/tools/cmd/goimports@latest
          -- go = { 'goimports', 'gofmt' },
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          bzl = { 'buildifier' },
          -- too many problems when using prettierd, runs but doesn't format
          jsonc = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          markdown = { 'prettier' },
          -- markdown = { 'prettier', 'mdformat', stop_after_first = true },
        },
        formatters = {
          shfmt = {
            prepend_args = { '-i', '2' },
          },
          -- require prettier config files to exist in the cwd
          -- before running it, useful to fallback to lsp when there isn't a config (json)
          prettier = {
            require_cwd = true,
          },
          prettierd = {
            require_cwd = true,
          },
        },
      }
    end,
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  {
    'dnlhc/glance.nvim',
    cmd = { 'Glance' },
    config = function()
      local glance = require 'glance'

      local function filterTypescriptDefinitionFiles(value)
        -- Depending on typescript version either uri or targetUri is returned
        if value.uri then
          return string.match(value.uri, '%.d.ts') == nil
        elseif value.targetUri then
          return string.match(value.targetUri, '%.d.ts') == nil
        end
      end

      ---@diagnostic disable-next-line: missing-fields
      glance.setup {
        theme = {
          enable = true, -- Generate colors based on current colorscheme
          mode = 'auto', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
        },

        border = {
          enable = false,
        },

        -- always render above the current window
        detached = function()
          return true
        end,

        ---@diagnostic disable-next-line: missing-fields
        mappings = {
          list = {
            ['j'] = glance.actions.next,
            ['k'] = glance.actions.previous,
            ['x'] = glance.actions.jump_split,
            ['l'] = glance.actions.jump,
            ['<c-t>'] = glance.actions.jump_tab,
            ['<c-v>'] = glance.actions.jump_vsplit,
            ['<c-h>'] = glance.actions.jump_split,
            ['<c-s>'] = glance.actions.jump_split,
            ['h'] = glance.actions.jump_split,
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        hooks = {
          before_open = function(results, open, _, method)
            if vim.islist(results) and #results > 1 and (method == 'definitions' or method == 'references') then
              local filtered_result = vim.tbl_filter(filterTypescriptDefinitionFiles, results)

              if #filtered_result > 0 then
                open(filtered_result)
              end
            else
              open(results)
            end
          end,
        },
      }
    end,
  },

  {
    'bassamsdata/namu.nvim',
    lazy = true,
    config = function()
      require('namu').setup {
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {
            display = {
              format = 'tree_guides',
            },
          },
        },
        -- Optional: Enable other modules if needed
        ui_select = { enable = false }, -- vim.ui.select() wrapper
      }
    end,
    keys = {
      { '<leader>fs', '<cmd>Namu symbols<cr>',   desc = 'Jump to LSP symbol' },
      { '<leader>fS', '<cmd>Namu workspace<cr>', desc = 'Jump to LSP workspace symbols' },
    },
  },

  -- syntax highlight for kcl language (.k files)
  { 'kcl-lang/kcl.nvim', lazy = false },

  {
    -- Improve lua ls for nvim config development
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },

        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim',        words = { 'Snacks' } },
      },
    },
  },
}
