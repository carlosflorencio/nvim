local M = {}

-- save buffer
-- if empty, ask for a file path to save
M.saveBuffer = function()
  local bufname = vim.api.nvim_buf_get_name(0)

  if bufname == "" then
    -- If the buffer doesn't have a name, ask the user for a file path
    local new_file_path = vim.fn.input {
      prompt = "Enter file path to save: ",
      default = vim.fn.getcwd(),
      completion = "dir",
    }
    if new_file_path ~= "" then
      bufname = new_file_path
    else
      vim.notify("Save aborted", "error")
      return
    end
  end

  -- Save the buffer to the determined file path
  vim.cmd("write " .. bufname)
end

M.runBuffer = function()
  local ft = vim.bo.filetype

  local table = {}
  table["json"] = "%!jq ."
  table["javascript"] = "!bun %"
  table["typescript"] = "!bun %"

  if table[ft] ~= nil then
    vim.cmd(table[ft])
  else
    vim.notify("Run buffer not supported for filetype " .. ft, "error")
  end
end

M.setBufferAsJson = function()
  vim.cmd [[set filetype=json]]
  M.runBuffer()
end

return M
