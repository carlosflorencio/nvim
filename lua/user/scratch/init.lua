local fs = require 'user.util.fs'
local strings = require 'user.util.strings'

local config = {
  scratch_dir = vim.fn.stdpath 'data' .. '/scratch/',
  default_name = '',
  split_cmd = 'tabe',
}

-- re-use existing scratch files
local filetype_tabs = {}

-- creates a new scratch file
local function new()
  fs.initDir(config.scratch_dir)

  local current_buffer = vim.api.nvim_get_current_buf()
  local current_buffer_ft = vim.api.nvim_get_option_value('filetype', { buf = current_buffer })
  local current_buffer_name = vim.api.nvim_buf_get_name(current_buffer)
  local current_buffer_extension = strings.get_extension(current_buffer_name)

  if current_buffer_extension == 'tsx' then
    current_buffer_ft = 'typescript'
    current_buffer_extension = 'ts'
  end

  -- check if a scratch buffer for this filetype already exists
  local saved_scratch = filetype_tabs[current_buffer_ft] or -1

  -- if a tabpage exists for current_buffer_ft, go to it instead of
  -- creating a new scratch buffer
  if saved_scratch ~= -1 then
    if vim.fn.index(vim.fn.map(vim.fn.gettabinfo(), 'v:val.tabnr'), saved_scratch) == -1 then
      filetype_tabs[current_buffer_ft] = nil
    else
      vim.cmd('tabn ' .. saved_scratch)
      return
    end
  end

  local get_name = function(number)
    return config.scratch_dir .. config.default_name .. current_buffer_ft .. number .. '.' .. current_buffer_extension
  end

  local scratch_num = 1
  local scratch_name = get_name(scratch_num)

  while vim.fn.filereadable(scratch_name) ~= 0 do
    scratch_num = scratch_num + 1
    scratch_name = get_name(scratch_num)
  end

  vim.api.nvim_command(config.split_cmd .. ' ' .. scratch_name)
  vim.bo.filetype = current_buffer_ft
  vim.cmd 'setlocal noswapfile buflisted bufhidden=hide'

  filetype_tabs[vim.bo.filetype] = vim.fn.tabpagenr()
end

-- performs a fuzzy find across scratch files
local function search()
  Snacks.picker.files {
    cwd = config.scratch_dir,
    -- ignored = true,
    -- confirm = function(picker, item)
    --   picker:close()
    --   if item then
    --     vim.schedule(function()
    --       vim.api.nvim_command('edit ' .. item._path)
    --     end)
    --   end
    -- end,
  }
end

local function setup()
  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('custom_scratch_file', { clear = true }),
    pattern = config.scratch_dir .. '*',
    callback = function(args)
      -- run SnipRun and restore cursor position
      -- vim.keymap.set('n', '<CR>', ':let b:caret=winsaveview() <CR> | :%SnipRun <CR>| :call winrestview(b:caret) <CR>', { buffer = args.buf })
      vim.keymap.set('n', '<CR>', '<cmd>Codi!!<cr>', { buffer = args.buf })
    end,
  })
end

local module = {
  new = new,
  search = search,
  setup = setup,
}

return module
