local window_width_limit = 100

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand '%:t') ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > window_width_limit
  end,
}

local colors = {
  bg = '#202328',
  fg = '#bbc2cf',
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  purple = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67',
}

local function env_cleanup(venv)
  if string.find(venv, '/') then
    local final_venv = venv
    for w in venv:gmatch '([^/]+)' do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

local function trunc(trunc_len)
  return function(str)
    if str:len() < trunc_len then
      return str
    end

    if str:match '%d$' ~= nil then
      -- could be a stacked pr, lets show the last chars
      local lastChars = 3
      local len = string.len(str)
      return str:sub(1, trunc_len - lastChars) .. '...' .. str:sub(len - lastChars + 1)
    else
      return str:sub(1, trunc_len) .. '...'
    end
  end
end

local function diff_source()
  ---@diagnostic disable-next-line: undefined-field
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local icons = require('user.icons').icons
local branch = icons.git.Branch

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == '' then
    return ''
  else
    return 'Recording @' .. recording_register
  end
end

return {
  mode = {
    function()
      return ' ' .. icons.ui.Target .. ' '
    end,
    padding = { left = 0, right = 0 },
    color = {},
    cond = nil,
  },
  cwd = {
    function()
      local dir_name = vim.fn.fnamemodify(vim.loop.cwd(), ':t')
      return dir_name
    end,
    -- fmt = function(path)
    --   return require('user.utils').shorten_path(path)
    -- end,
    icon = icons.ui.Folder,
    padding = { left = 1, right = 1 },
  },
  branch = {
    'b:gitsigns_head',
    icon = branch,
    fmt = trunc(30),
  },
  filename = {
    'filename',
    color = {},
    cond = nil,
  },
  recording_macro = {
    'macro-recording',
    fmt = show_macro_recording,
  },
  diff = {
    'diff',
    source = diff_source,
    symbols = {
      added = icons.git.LineAdded .. ' ',
      modified = icons.git.LineModified .. ' ',
      removed = icons.git.LineRemoved .. ' ',
    },
    padding = { left = 2, right = 1 },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    cond = nil,
  },
  python_env = {
    function()
      if vim.bo.filetype == 'python' then
        local venv = os.getenv 'CONDA_DEFAULT_ENV' or os.getenv 'VIRTUAL_ENV'
        if venv then
          local py_icon, _ = require('nvim-web-devicons').get_icon '.py'
          return string.format(' ' .. py_icon .. ' (%s)', env_cleanup(venv))
        end
      end
      return ''
    end,
    color = { fg = colors.green },
    cond = conditions.hide_in_width,
  },
  diagnostics = {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = {
      error = icons.diagnostics.BoldError .. ' ',
      warn = icons.diagnostics.BoldWarning .. ' ',
      info = icons.diagnostics.BoldInformation .. ' ',
      hint = icons.diagnostics.BoldHint .. ' ',
    },
    -- cond = conditions.hide_in_width,
  },
  treesitter = {
    function()
      return icons.ui.Tree
    end,
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
    end,
    cond = conditions.hide_in_width,
  },
  location = { 'location' },
  progress = {
    'progress',
    fmt = function()
      return '%P/%L'
    end,
    color = {},
  },
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_get_option_value('shiftwidth', { buf = 0 })
      return icons.ui.Tab .. ' ' .. shiftwidth
    end,
    padding = 1,
  },
  encoding = {
    'o:encoding',
    fmt = string.upper,
    color = {},
    cond = conditions.hide_in_width,
  },
  filetype = { 'filetype', cond = nil, padding = { left = 1, right = 1 } },
  scrollbar = {
    function()
      local current_line = vim.fn.line '.'
      local total_lines = vim.fn.line '$'
      local chars = { '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██' }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    padding = { left = 0, right = 0 },
    color = 'SLProgress',
    cond = nil,
  },
}
