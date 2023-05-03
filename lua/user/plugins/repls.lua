return {
  {
    -- scratch files
    "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
  },

  {
    -- inline run code
    "michaelb/sniprun",
    cmd = { "SnipRun" },
    build = "bash ./install.sh",
  },
}
