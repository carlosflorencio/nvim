local wk = require("which-key")

local opts = { prefix = ",", buffer = 0 }

wk.register({
  r = {
    name = "Run",
    u = { "<Plug>RestNvim", "Run request under cursor" }
  }
}, opts)

