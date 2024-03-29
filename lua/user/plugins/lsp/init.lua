return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettierd",
        "actionlint",
        "proselint",
        "delve",
        "js-debug-adapter",
        -- "cspell", -- install globally using npm
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "denols",
        "tsserver",
        "bashls",
        "cssls",
        "eslint",
        "html",
        "dockerls",
        "jsonls",
        "gopls",
        "tailwindcss",
        "marksman",
        "taplo", --toml
        "quick_lint_js",
        "vimls",
        "yamlls",
        "pyright",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- event = "VeryLazy",
    -- lazy = false,
    dependencies = {
      -- {
      --   "folke/neoconf.nvim",
      --   cmd = "Neoconf",
      --   config = true,
      -- },
      {
        "folke/neodev.nvim",
        enabled = true,
        opts = {},
      },
      "williamboman/mason-lspconfig.nvim",
      { "hrsh7th/cmp-nvim-lsp" },
      {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
      },
      { "lvimuser/lsp-inlayhints.nvim", opts = {} },
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "neovim/nvim-lspconfig",
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = {
          lsp = {
            auto_attach = true,
            preference = { "typescript-tools", "lua_ls", "tsserver", "pyright" },
          },
        },
        keys = {
          { "<leader>fs", "<cmd>Navbuddy<cr>", desc = "Navbuddy navigate LSP symbols" },
        },
      },
    },
    config = function()
      local lsputils = require "user.plugins.lsp.utils"
      local lspconfig = require "lspconfig"

      local capabilities = lsputils.capabilities()

      require("user.util").on_attach(lsputils.on_attach)

      -- setup defaults
      lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = capabilities,
      })

      lspconfig["lua_ls"].setup {
        settings = {
          Lua = {
            hint = {
              enable = false,
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      }

      lspconfig["tailwindcss"].setup {
        root_dir = lspconfig.util.root_pattern(
          "tailwind.config.js",
          "tailwind.config.ts",
          "postcss.config.js",
          "postcss.config.ts"
        ),
      }

      -- lspconfig["intelephense"].setup {}
      lspconfig["phpactor"].setup {}

      lspconfig["gopls"].setup {}

      lspconfig["html"].setup {}

      lspconfig["starlark_rust"].setup {}

      lspconfig["rust_analyzer"].setup {}

      lspconfig["pyright"].setup {}

      lspconfig["eslint"].setup {
        settings = {
          eslint = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
      }

      lspconfig["jsonls"].setup {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
      }

      lspconfig["yamlls"].setup {
        settings = {
          yaml = {
            schemas = require("schemastore").yaml.schemas {
              extra = {
                {
                  description = "K8s Config Map",
                  fileMatch = { "**/config-maps/**/*.yaml" },
                  name = "K8s Config Map",
                  url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/configmap.json",
                },
                {
                  description = "K8s Job",
                  fileMatch = { "job.yml" },
                  name = "K8s Job",
                  url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.27.4/job.json",
                },
              },
            },
          },
        },
      }

      lspconfig["denols"].setup {
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
      }

      -- require("typescript").setup {
      --   server = { -- pass options to lspconfig's setup method
      --     capabilities = capabilities,
      --     root_dir = lspconfig.util.root_pattern(".git", "package-lock.json", "yarn.lock"),
      --     init_options = {
      --       preferences = {
      --         importModuleSpecifierPreference = "relative",
      --       },
      --     },
      --     settings = {
      --       completions = {
      --         completeFunctionCalls = true,
      --       },
      --       typescript = {
      --         -- https://github.com/typescript-language-server/typescript-language-server#inlay-hints-textdocumentinlayhint
      --         inlayHints = {
      --           -- includeInlayFunctionParameterTypeHints = true,
      --           -- includeInlayFunctionLikeReturnTypeHints = true,
      --           -- includeInlayEnumMemberValueHints = true,
      --         },
      --       },
      --     },
      --     -- https://github.com/davidosomething/format-ts-errors.nvim
      --     handlers = {
      --       ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
      --         if result.diagnostics == nil then
      --           return
      --         end

      --         -- ignore some tsserver diagnostics
      --         local idx = 1
      --         while idx <= #result.diagnostics do
      --           local entry = result.diagnostics[idx]

      --           local formatter = require("format-ts-errors")[entry.code]
      --           entry.message = formatter and formatter(entry.message) or entry.message

      --           -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
      --           if entry.code == 80001 then
      --             -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
      --             table.remove(result.diagnostics, idx)
      --           else
      --             idx = idx + 1
      --           end
      --         end

      --         vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
      --       end,
      --     },
      --   },
      -- }

      -- diagnostics
      for name, icon in pairs(require("user.ui").lsp_diagnostic_icons) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, {
          text = icon,
          texthl = name,
          numhl = "",
        })
      end

      local updated_diagnostics = {
        underline = false,
        update_in_insert = false,
        -- virtual_text = {
        --   spacing = 1,
        --   prefix = "",
        -- },
        virtual_text = false,
        severity_sort = true,
        float = {
          border = "rounded",
        },
      }
      vim.diagnostic.config(updated_diagnostics)
    end,
  },

  -- {
  --   "ThePrimeagen/refactoring.nvim",
  --   dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-treesitter/nvim-treesitter" } },
  --   opts = {},
  -- },

  {
    "dnlhc/glance.nvim",
    cmd = { "Glance" },
    config = function()
      local glance = require "glance"
      local lsputils = require "user.plugins.lsp.utils"

      glance.setup {
        mappings = {
          list = {
            ["j"] = glance.actions.next_location,
            ["k"] = glance.actions.previous_location,
            ["x"] = glance.actions.jump_split,
            ["<c-t>"] = glance.actions.jump_tab,
            ["<c-v>"] = glance.actions.jump_vsplit,
            ["<c-x>"] = glance.actions.jump_split,
          },
        },
        hooks = {
          before_open = function(results, open, jump, method)
            if vim.tbl_islist(results) and #results > 1 and (method == "definitions" or method == "references") then
              local filtered_result = vim.tbl_filter(lsputils.filterTypescriptDefinitionFiles, results)

              if #filtered_result > 0 then
                open(filtered_result)
              end
            else
              open(results)
            end
          end,
        },
        folds = {
          -- required to fix the nerd fonts v3 upgrade
          -- fold_closed = require("user.ui").icons.ui.ChevronShortRight,
          -- fold_open = require("user.ui").icons.ui.ChevronShortDown,
          -- folded = true,
        },
      }
    end,
  },

  -- { "davidosomething/format-ts-errors.nvim" },
  -- { "jose-elias-alvarez/typescript.nvim" },

  {
    "pmizio/typescript-tools.nvim",
    enabled = true,
    ft = { "typescript", "typescriptreact", "javascript" },
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local mason_registry = require "mason-registry"
      local tsserver_path = mason_registry.get_package("typescript-language-server"):get_install_path()
      require("typescript-tools").setup {
        root_dir = require("lspconfig").util.root_pattern(".git", "package-lock.json", "yarn.lock"),
        settings = {
          -- tsserver_path = tsserver_path .. "/node_modules/typescript/lib/tsserver.js",
          tsserver_file_preferences = {
            importModuleSpecifierPreference = "relative",
            -- includeInlayParameterNameHints = "all",
            -- includeInlayEnumMemberValueHints = true,
            -- includeInlayFunctionLikeReturnTypeHints = true,
            -- includeInlayFunctionParameterTypeHints = true,
            -- includeInlayPropertyDeclarationTypeHints = true,
            -- includeInlayVariableTypeHints = true
          },
          -- tsserver_plugins = { "typescript-styled-plugin" },
        },
      }
    end,
  },
}
