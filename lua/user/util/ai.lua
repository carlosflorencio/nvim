local M = {}

M.is_llm_chat_buffer = function()
  local ft = { 'copilot-chat', 'codecompanion' }
  return vim.tbl_contains(ft, vim.bo.filetype)
end

M.accept = function()
  if package.loaded['supermaven-nvim'] then
    require('supermaven-nvim.completion_preview').on_accept_suggestion()
    return
  end

  -- copilot.lua
  if package.loaded['copilot'] then
    require('copilot.suggestion').accept()
    return
  end

  -- copilot.vim
  if vim.g.loaded_copilot then
    vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
    return
  end
end

-- require('copilot.api').register_status_notification_handler(function(data)
--   print('Copilot Status: ' .. data.status)
-- end)

M.suggest = function()
  -- copilot.lua
  if package.loaded['copilot'] then
    require('copilot.suggestion').next()
    return
  end

  -- print(vim.inspect 'suggest')
  if vim.g.loaded_copilot then
    vim.api.nvim_feedkeys(vim.fn['copilot#Suggest'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
    -- local copilot_keys = vim.fn['copilot#Suggest']()
    -- if copilot_keys ~= '' then
    --   vim.api.nvim_feedkeys(copilot_keys, 'i', true)
    -- end
    return
  end
end

M.has_suggestions = function()
  if package.loaded['supermaven-nvim'] then
    return require('supermaven-nvim.completion_preview').has_suggestion()
  end

  -- copilot.lua
  if package.loaded['copilot'] then
    return require('copilot.suggestion').is_visible()
  end

  -- copilot.vim
  if vim.g.loaded_copilot then
    return vim.fn.exists '*copilot#GetDisplayedSuggestion' ~= 0 and vim.fn['copilot#GetDisplayedSuggestion']()['text'] ~= ''
  end

  return false
end

M.next_suggestion = function()
  -- copilot.lua
  if package.loaded['copilot'] then
    require('copilot.suggestion').next()
  end

  -- copilot.vim
  if vim.g.loaded_copilot then
    vim.fn['copilot#Next']()
  end
end

M.previous_suggestion = function()
  -- copilot.lua
  if package.loaded['copilot'] then
    require('copilot.suggestion').prev()
  end

  -- copilot.vim
  if vim.g.loaded_copilot then
    vim.fn['copilot#Previous']()
  end
end

M.panel = function()
  -- copilot.vim
  if vim.g.loaded_copilot then
    vim.cmd 'Copilot panel'
  end
end

return M
