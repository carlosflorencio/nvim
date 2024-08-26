local M = {}

function M.has_words_before(word)
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))

  if not word then
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
  end

  local line_text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  local previous_word = line_text:sub(1, col - #word)
  previous_word = previous_word:gsub('%s', '') -- ignore whitespace

  return #previous_word > 0
end

function M.is_insert_mode()
  return vim.api.nvim_get_mode().mode:sub(1, 1) == 'i'
end

function M.get_file_type(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_get_option_value('filetype', { buf = bufnr })
end

return M
