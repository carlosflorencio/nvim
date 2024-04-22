local M = require('lualine.component'):extend()

local function get_current_diagnostic()
  local bufnr = 0
  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local opts = { ['lnum'] = line_nr }

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then
    return
  end

  local best_diagnostic = nil

  for _, diagnostic in ipairs(line_diagnostics) do
    if best_diagnostic == nil or diagnostic.severity < best_diagnostic.severity then
      best_diagnostic = diagnostic
    end
  end

  return best_diagnostic
end

function M:init(options)
  -- options.icon = options.icon or '󰌘'
  -- options.split = options.split or ', '
  M.super.init(self, options)
end

function M:update_status()
  local diagnostic = get_current_diagnostic()

  if not diagnostic or not diagnostic.message then
    return
  end

  local message = vim.split(diagnostic.message, '\n')[1]
  local max_width = vim.api.nvim_win_get_width(0) - 35

  if string.len(message) < max_width then
    return message
  else
    return string.sub(message, 1, max_width) .. '...'
  end
end

return M
