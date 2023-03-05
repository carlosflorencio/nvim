return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      local keymaps = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>c"] = { name = "+close" },
        ["<leader>l"] = { name = "+lsp" },
        ["<leader>f"] = { name = "+find/file" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+split" },
        ["<leader>t"] = { name = "+toggle" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>o"] = { name = "+organize/reviews" },
        [",t"] = {name = "+test"}
      }
      wk.register(keymaps)
    end,
  },

  {
    -- improved marks
    "chentoast/marks.nvim",
    opts = {},
    lazy = false
  },

  {
    "wellle/targets.vim",
    lazy = false
  },

  {
    -- Image asci previewer
    'samodostal/image.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    opts = {},
    lazy = false
  },
}