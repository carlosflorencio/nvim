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
        "cspell", -- install globally using npm
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
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- event = "VeryLazy",
    -- lazy = false,
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        config = true,
      },
      {
        "folke/neodev.nvim",
        opts = {
          experimental = {
            pathStrict = true,
          },
        },
      },
      "williamboman/mason-lspconfig.nvim",
      { "hrsh7th/cmp-nvim-lsp" },
      {
        "b0o/SchemaStore.nvim",
        version = false, -- last release is way too old
      },
      { "jose-elias-alvarez/typescript.nvim" },
      { "lvimuser/lsp-inlayhints.nvim", opts = {} },
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

      lspconfig["html"].setup {}

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
            schemas = require("schemastore").json.schemas(),
          },
        },
      }

      lspconfig["denols"].setup {
        root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
      }

      require("typescript").setup {
        server = { -- pass options to lspconfig's setup method
          capabilities = capabilities,
          root_dir = lspconfig.util.root_pattern(".git", "package-lock.json"),
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "relative",
            },
          },
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
            typescript = {
              -- https://github.com/typescript-language-server/typescript-language-server#inlay-hints-textdocumentinlayhint
              inlayHints = {
                -- includeInlayFunctionParameterTypeHints = true,
                -- includeInlayFunctionLikeReturnTypeHints = true,
                -- includeInlayEnumMemberValueHints = true,
              },
            },
          },
          -- https://github.com/davidosomething/format-ts-errors.nvim
          handlers = {
            ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
              if result.diagnostics == nil then
                return
              end

              -- ignore some tsserver diagnostics
              local idx = 1
              while idx <= #result.diagnostics do
                local entry = result.diagnostics[idx]

                local formatter = require("format-ts-errors")[entry.code]
                entry.message = formatter and formatter(entry.message) or entry.message

                -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
                if entry.code == 80001 then
                  -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
                  table.remove(result.diagnostics, idx)
                else
                  idx = idx + 1
                end
              end

              vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
            end,
          },
        },
      }

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
        -- hooks = {
        --   before_open = function(results, open, jump, method)
        --     if method == "references" and #results == 2 then
        --       -- If 2 references, then jump to the other reference
        --       local curr_line = unpack(vim.api.nvim_win_get_cursor(0))
        --       for i, ref in ipairs(results) do
        --         if ref.range.start.line + 1 == curr_line then
        --           jump(results[i % 2 + 1])
        --           return
        --         end
        --       end
        --       open(results)
        --     elseif #results == 1 then
        --       jump(results[1])
        --       return
        --     end
        --     open(results)
        --   end,
        -- },
        folds = {
          -- required to fix the nerd fonts v3 upgrade
          fold_closed = require("user.ui").icons.ui.ChevronShortRight,
          fold_open = require("user.ui").icons.ui.ChevronShortDown,
          folded = true,
        },
      }
    end,
  },

  { "davidosomething/format-ts-errors.nvim" },
}
