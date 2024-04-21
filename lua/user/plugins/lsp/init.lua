return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
      {
        'b0o/SchemaStore.nvim',
        version = false, -- last release is way too old
      },

      {
        'SmiteshP/nvim-navbuddy',
        dependencies = {
          'neovim/nvim-lspconfig',
          'SmiteshP/nvim-navic',
          'MunifTanjim/nui.nvim',
        },
        opts = {
          lsp = {
            auto_attach = true,
            preference = { 'typescript-tools', 'lua_ls', 'tsserver', 'pyright' },
          },
          window = {
            size = '75%',
          },
        },
        keys = {
          { '<leader>fs', '<cmd>Navbuddy<cr>', desc = 'Navbuddy navigate LSP symbols' },
        },
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

      local servers = {
        html = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        bzl = {},

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
              schemas = require('schemastore').yaml.schemas {
                extra = {
                  {
                    description = 'K8s Config Map',
                    fileMatch = { '**/config-maps/**/*.yaml' },
                    name = 'K8s Config Map',
                    url = 'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/configmap.json',
                  },
                  {
                    description = 'K8s Job',
                    fileMatch = { 'job.yml' },
                    name = 'K8s Job',
                    url = 'https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/job.json',
                  },
                },
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'typescript-language-server',
        'prettierd',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            -- ignore servers that are being setup by another plugin
            local ignore = { 'tsserver' }
            if vim.tbl_contains(ignore, server_name) then
              return
            end

            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'typescriptreact', 'javascript' },
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      require('typescript-tools').setup {
        root_dir = require('lspconfig').util.root_pattern('.git', 'package-lock.json', 'yarn.lock'),
      }
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
        mode = '',
        desc = 'Format buffer',
      },
    },
    config = function()
      require('conform').setup {
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
        -- Define your formatters
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          javascript = { { 'prettierd', 'prettier' } },
          typescript = { { 'prettierd', 'prettier' } },
        },
        -- Set up format-on-save
        -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
        -- Customize formatters
        formatters = {
          shfmt = {
            prepend_args = { '-i', '2' },
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
        ---@diagnostic disable-next-line: missing-fields
        mappings = {
          list = {
            ['j'] = glance.actions.next_location,
            ['k'] = glance.actions.previous_location,
            ['x'] = glance.actions.jump_split,
            ['l'] = glance.actions.jump,
            ['<c-t>'] = glance.actions.jump_tab,
            ['<c-v>'] = glance.actions.jump_vsplit,
            ['<c-x>'] = glance.actions.jump_split,
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        hooks = {
          before_open = function(results, open, _, method)
            if vim.tbl_islist(results) and #results > 1 and (method == 'definitions' or method == 'references') then
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
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup {
        autocmd = { enabled = true },
      }
    end,
  },
}
