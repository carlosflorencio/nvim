return {
    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp-signature-help",
        },
        config = function()
            local cmp = require 'cmp'

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<TAB>'] = cmp.mapping.confirm({ select = true })
                  }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp_signature_help" },
                    { name = 'nvim_lsp' },
                    { name = "buffer" },
                    { name = "nvim_lua" },
                }, {
                    -- group 2 only if nothing in above had results
                    { name = "path" }
                }),
                completion = {
                    completeopt = 'menu,menuone,noinsert',
                },

            })
        end
    },
}
