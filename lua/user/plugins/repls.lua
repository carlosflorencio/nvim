return {
  {
    -- scratch files
    "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
    init = function()
      vim.g["codi#rightalign"] = 0
      vim.g["codi#autoclose"] = 0
      vim.g["codi#virtual_text"] = 0
    end,
  },

  {
    -- inline run code
    "michaelb/sniprun",
    build = "sh ./install.sh",
    cmd = { "SnipRun" },
    opts = {
      -- display = { "Terminal" },
    },
  },
}
