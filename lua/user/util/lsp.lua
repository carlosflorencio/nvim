local M = {}

--- Gets LSP errors for the current buffer and formats them.
---@param opts? { join?: boolean, join_char?: string } Optional options table.
---  - `join` (boolean, optional): If `false`, returns a table of error messages. Defaults to `true` (returns a single string with messages joined by newlines).
---  - `join_char` (string, optional): The character used to join error messages when `join` is not `false`. Defaults to `\n` (newline).
---@return string | string[] A single string with all error messages joined by the specified `join_char` (defaulting to newlines), or a table of error message strings if `opts.join` is `false`.
M.get_lsp_errors = function(opts)
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
        'Line %d: %s \nCode: %s',
        diagnostic.lnum + 1, -- Convert 0-based line number to 1-based
        diagnostic.message,
        error_line
      )
      table.insert(error_messages, message)
    end
  end

  if opts and opts.join == false then
    -- If 'opts.join' is explicitly false, return the table of error messages
    return error_messages
  end

  -- By default, or if opts.join is not false, concatenate messages into a single string
  local join_separator = '\n' -- Default separator
  if opts and opts.join_char ~= nil then -- Check if join_char is explicitly provided
    join_separator = opts.join_char
  end
  return table.concat(error_messages, join_separator)
end

return M
