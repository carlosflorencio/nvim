local M = {}

---@param haystack string
---@param needle string
---@return boolean found true if needle in haystack
M.starts_with = function(haystack, needle)
  return haystack:sub(1, needle:len()) == needle
end

--- Trim string
---@param s string
---@return string
function M.trim(s)
  return (s:gsub('^%s*(.-)%s*$', '%1'))
end

--- Split string to a list
---@param inputstr string to split
---@param sep string Separator
---@return List
function M.split(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

function M.get_extension(fileName)
  local extension = fileName:match '^.+(%..+)$'
  if extension then
    return extension:sub(2)
  else
    return nil
  end
end

return M
