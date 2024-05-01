local M = {}

-- Create a directory if it doesn't exist
function M.initDir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, 'p')
  end
end

-- Get the file type for a given extension
function M.getFileTypeForExtension(ext)
  local fileTypes = {
    ts = 'typescript',
    py = 'python',
    js = 'javascript',
  }

  if fileTypes[ext] ~= nil then
    return fileTypes[ext]
  end

  return nil
end

return M
