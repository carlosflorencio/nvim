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
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      local is_insert_mode = function()
        return vim.api.nvim_get_mode().mode:sub(1, 1) == 'i'
      end

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      cmp.setup {
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
            if vim.bo.filetype == 'markdown' then
              -- prevent messing with mkdnflow tab
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            else
              if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                  cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                else
                  cmp.confirm()
                end
              elseif require('copilot.suggestion').is_visible() then
                require('copilot.suggestion').accept()
              else
                if luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                -- elseif cmp_utils.has_words_before() then
                --   cmp.complete()
                -- -- fallback()
                else
                  fallback()
                end
              end
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
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping(function(fallback)
            if vim.bo.filetype == 'markdown' then
              if cmp.visible() then
                cmp.confirm()
              else
                fallback()
              end
            else
              local debug = {
                visible = cmp.visible(),
                active_entry = cmp.get_active_entry(),
                luasnip = luasnip.expand_or_locally_jumpable(),
                has_words_before = has_words_before(),
              }
              print(vim.inspect(debug))
              if cmp.visible() and cmp.get_active_entry() then
                local confirm_opts = {
                  behavior = cmp.ConfirmBehavior.Replace,
                  select = false,
                }
                if is_insert_mode() then -- prevent overwriting brackets
                  confirm_opts.behavior = cmp.ConfirmBehavior.Insert
                end
                print(vim.inspect(confirm_opts))
                print(vim.inspect(is_insert_mode()))
                if cmp.confirm(confirm_opts) then
                  return -- success, exit early
                end
                fallback()
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end
          end),
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'luasnip' },
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
      {
        'rafamadriz/friendly-snippets',
        config = function()
          -- require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    -- follow latest release.
    version = 'v2.*',
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',
    opts = {
      enable_autosnippets = true,
    },
    config = function(_, opts)
      local luasnip = require 'luasnip'
      luasnip.setup(opts)

      luasnip.filetype_extend('javascriptreact', { 'html' })
      luasnip.filetype_extend('typescriptreact', { 'html' })

      -- require "user.plugins.cmp.snippets"
      require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets' } }
    end,
  },
}
