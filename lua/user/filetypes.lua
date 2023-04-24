vim.filetype.add {
  extension = {
    conf = "conf",
  },
  filename = {
    [".env"] = "dotenv",
    [".env.development"] = "dotenv",
    [".env.local"] = "dotenv",
    [".env.production"] = "dotenv",
    ["tsconfig.json"] = "jsonc",
  },
}

-- check ../plugins/treesitter.lua to enable ts highlighting for new filetypes
