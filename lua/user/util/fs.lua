local M = {}

function M.initDir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

function M.getFileTypeForExtension(ext)
  local fileTypes = {
    ts = "typescript",
    py = "python",
    js = "javascript",
  }

  if fileTypes[ext] ~= nil then
    return fileTypes[ext]
  end

  return nil
end

return M
