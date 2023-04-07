return {
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
        preference = { "lua_ls", "tsserver", "pyright" },
      },
    },
    -- auto attach to lsp
    event = "BufReadPre",
    keys = {
      { "<leader>fs", "<cmd>Navbuddy<cr>", desc = "Navbuddy navigate LSP symbols" },
    },
  },
}
