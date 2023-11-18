local M = {}

-- Disables: scrollbar, cspell, illuminate
-- Other places: indent blank line, lualine, cmp
M.disabled_filetypes = {
  "dirvish",
  "noice",
  "harpoon",
  "fugitive",
  "alpha",
  "NvimTree",
  "oil",
  "lazy",
  "neogitstatus",
  "Trouble",
  "lir",
  "dashboard",
  "Outline",
  "spectre_panel",
  "toggleterm",
  "DressingSelect",
  "TelescopePrompt",
  "dapui_watches",
  "help",
  "lspinfo",
  "man",
  "checkhealth",
  "dapui_breakpoints",
  "dapui_scopes",
  "dapui_console",
  "dapui_stacks",
  "dap-repl",
  "chatgpt-input",
}

return M
