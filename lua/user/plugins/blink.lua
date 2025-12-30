return {
  {
    'saghen/blink.cmp',
    -- needed because of samiulsami/cmp-go-deep
    dependencies = {
      { 'samiulsami/cmp-go-deep', dependencies = { 'kkharji/sqlite.lua' } },
      { 'saghen/blink.compat' },
    },
    -- use a release tag to download pre-built binaries
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = 'luasnip' },

      keymap = {
        -- trigger
        ['<C-ESC>'] = { 'show', 'show_documentation', 'hide_documentation' },
        -- decision
        -- ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'accept', 'snippet_forward', 'fallback' },
        -- ['<Tab>'] = {
        --   function(cmp)
        --     if require('user.util.ai').has_suggestions() then
        --       require('user.util.ai').accept()
        --       return true -- doesn't run the next command
        --     end

        --     return -- runs the next command
        --   end,
        --   'accept',
        --   'snippet_forward',
        --   'fallback',
        -- },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-e>'] = { 'hide' },
        -- docs
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = true },
        list = {
          selection = {
            -- preselect = false,
            -- auto_select = false,
          },
        },
        menu = {
          draw = {
            -- We don't need label_description now because label and label_description are already
            -- combined together in label by colorful-menu.nvim.
            columns = { { 'label', gap = 1 }, { 'kind', 'source_name', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'go_deep' },
        providers = {
          go_deep = {
            name = 'go_deep',
            module = 'blink.compat.source',
            min_keyword_length = 3,
            max_items = 5,
            ---@module "cmp_go_deep"
            ---@type cmp_go_deep.Options
            opts = {},
          },
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      signature = { enabled = true, window = { show_documentation = true } },

      cmdline = {
        enabled = true,
        keymap = {
          ['<Up>'] = { 'select_prev', 'fallback' },
          ['<Down>'] = { 'select_next', 'fallback' },
          ['<C-ESC>'] = { 'show', 'show_documentation', 'hide_documentation' },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'xzbdmw/colorful-menu.nvim',
    lazy = true,
    opts = {},
  },
}
