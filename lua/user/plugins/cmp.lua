return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'onsails/lspkind.nvim',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'
      local buffers = require 'user.util.buffers'

      cmp.setup {
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text', -- show only symbol annotations
            -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            -- ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            -- before = function(entry, vim_item)
            --   ...
            --   return vim_item
            -- end,
          },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
          ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
          ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select }, { 'i' }),
          ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select }, { 'i' }),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping {
            i = cmp.mapping.confirm { behavior = cmp.SelectBehavior.Replace, select = false },
            c = function(fallback)
              if cmp.visible() then
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
              else
                fallback()
              end
            end,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if not cmp.visible() and require('copilot.suggestion').is_visible() then
              require('copilot.suggestion').accept()
            elseif cmp.visible() then
              -- auto expand luasnip
              -- if luasnip.expandable() then
              --   luasnip.expand()
              --   return
              -- end

              cmp.confirm { select = true }
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            elseif buffers.has_words_before() then
              cmp.complete()
              if #cmp.get_entries() == 1 then
                cmp.confirm { select = true }
              end
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-TAB>'] = cmp.mapping.complete(),
          ['<C-ESC>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if cmp.get_active_entry() then
                cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
              else
                fallback()
              end
            else
              fallback()
            end
          end),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp_signature_help' },
          {
            name = 'nvim_lsp',
            entry_filter = function(entry, ctx)
              local kind = require('cmp.types.lsp').CompletionItemKind[entry:get_kind()]
              if kind == 'Snippet' and ctx.prev_context.filetype == 'java' then
                return false
              end

              -- tsserver Keywords (if, for) appear first than Snippets
              -- remove them
              local ignore_kinds = { 'Keyword', 'Text' }
              if vim.tbl_contains(ignore_kinds, kind) then
                return false
              end

              return true
            end,
          },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'nvim_lua' }, -- vim api completion
        }, {
          -- group 2 only if nothing in above had results
          { name = 'path' },
        }),
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
      }
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
    },
    -- follow latest release.
    version = 'v2.*',
    build = 'make install_jsregexp',
    opts = {
      enable_autosnippets = true,
    },
    config = function(_, opts)
      local luasnip = require 'luasnip'
      luasnip.setup(opts)

      luasnip.filetype_extend('javascriptreact', { 'html' })
      luasnip.filetype_extend('typescriptreact', { 'html' })
      -- i don't want this, snippets appear duplicated
      -- luasnip.filetype_extend('javascript', { 'typescript' })

      require 'user.snippets.typescript'
      require 'user.snippets.lua'
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets' } }
    end,
  },
}
