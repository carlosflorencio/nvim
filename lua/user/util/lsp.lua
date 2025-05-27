local M = {}

-- Function to get LSP errors and format them into a string
M.get_lsp_errors = function(join)
  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the full file path of the current buffer
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Make the file path relative to the current working directory
  local relative_filepath = vim.fn.fnamemodify(filepath, ':.')

  -- Get diagnostics for the current buffer
  local diagnostics = vim.diagnostic.get(bufnr)

  -- Initialize a table to hold error strings
  local error_messages = {}

  -- Add the relative file path to the beginning of the error messages
  table.insert(error_messages, 'File: ' .. relative_filepath)

  -- Iterate over diagnostics and format them
  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      -- Get the line of code where the error occurs
      local error_line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)[1]

      local message = string.format(
        'Line %d: %s\nCode: %s',
        diagnostic.lnum + 1, -- Convert 0-based line number to 1-based
        diagnostic.message,
        error_line
      )
      table.insert(error_messages, message)
    end
  end

  if join == false then
    -- If 'join' false, return the table of error messages
    return error_messages
  end

  return table.concat(error_messages, '\n')
end

return M
