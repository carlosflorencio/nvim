local M = {}

-- + darkens and - lightens the tone
M.lightenDarken = function(col, amt)
  local num = tonumber(col, 16)
  local r = bit.rshift(num, 16) + amt
  local b = bit.band(bit.rshift(num, 8), 0x00FF) + amt
  local g = bit.band(num, 0x0000FF) + amt
  local newColor = bit.bor(g, bit.bor(bit.lshift(b, 8), bit.lshift(r, 16)))
  return string.format('#%X', newColor)
end

M.colors = {
  bg = '#000000',
  accent = '#223E55',
  error = '#EC8080',

  debugRed = '#FF0000',
  debugGreen = '#00FF00',
}

M.colors.lineSeparators = M.lightenDarken(M.colors.bg:sub(2), 30)
M.colors.bgStatusLine = M.lightenDarken(M.colors.bg:sub(2), 20)

return M
