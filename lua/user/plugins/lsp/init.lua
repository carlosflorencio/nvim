return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    branch = 'master',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason.nvim',
      { 'williamboman/mason-lspconfig.nvim', branch = 'main' },
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- { 'j-hui/fidget.nvim', opts = {} },

      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            { path = 'snacks.nvim', words = { 'Snacks' } },
          },
        },
      },
      { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings

      {
        'b0o/SchemaStore.nvim',
        version = false, -- last release is way too old
      },
    },
    config = function()
      require 'user.plugins.lsp.lsp-keymaps'
      local lspconfig = require 'lspconfig'

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
      -- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
      capabilities.workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      }

      local servers = {
        html = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        -- starpls has jump to definition support
        starpls = {},
        -- starlark_rust has better linting rules (e.g import not used)
        starlark_rust = {},
        -- bzl = {},

        denols = {
          root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
        },

        eslint = {
          settings = {
            eslint = {
              -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
              workingDirectory = { mode = 'auto' },
            },
          },
        },

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
              -- manually linking schemas because github workflow schema is
              -- broken in schemastore
              -- https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
              schemas = {
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                ['https://json.schemastore.org/pre-commit-config.json'] = '/.pre-commit-config.*',
                ['https://json.schemastore.org/swagger-2.0.json'] = '**/swagger.yaml',
                ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/configmap.json'] = '**/config-maps/**/*.yaml',
                ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/job.json'] = 'job.yml',
                ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/pod.json'] = 'pod.yml',
                ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose*.yml',
                ['https://json.schemastore.org/commitlintrc.json'] = '.commitlintrc.yml',
              },
            },
          },
        },

        -- personal notes lsp
        -- auto completion links [[]]
        ['markdown-oxide'] = {},
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'typescript-language-server',
        'prettierd',
        'mdformat',
      })

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            -- ignore servers that are being setup by another plugin
            -- mdformat needs to be installed globally with github markdown flavour
            -- https://github.com/executablebooks/mdformat?tab=readme-ov-file#installing
            local ignore = { 'ts_ls', 'mdformat' }
            if vim.tbl_contains(ignore, server_name) then
              return
            end

            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- diagnostics
      for name, icon in pairs(require('user.icons').lsp_diagnostic_icons) do
        name = 'DiagnosticSign' .. name
        vim.fn.sign_define(name, {
          text = icon,
          texthl = name,
          numhl = '',
        })
      end

      local updated_diagnostics = {
        underline = false,
        update_in_insert = false,
        -- virtual_text = {
        --   spacing = 1,
        --   prefix = "",
        -- },
        -- virtual_text = {
        --   source = true,
        -- },
        virtual_text = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = true,
        },
      }
      vim.diagnostic.config(updated_diagnostics)
    end,
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
    'SmiteshP/nvim-navbuddy',
    lazy = true,
    dependencies = {
      'neovim/nvim-lspconfig',
      'SmiteshP/nvim-navic',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      lsp = {
        auto_attach = true,
        preference = { 'typescript-tools', 'lua_ls', 'ts_ls', 'pyright' },
      },
      window = {
        size = '75%',
      },
    },
    keys = {
      { '<leader>fs', '<cmd>Navbuddy<cr>', desc = 'Navbuddy navigate LSP symbols' },
    },
  },
}
