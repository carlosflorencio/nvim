local fs = require 'user.util.fs'
local strings = require 'user.util.strings'

local config = {
  -- ignore by git
  scratch_dir = vim.fn.stdpath 'data' .. '/scratch/',
  default_name = '',
  default_type = 'txt',
  split_cmd = 'tabe',
  backend = 'telescope.builtin',
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
      -- print(vim.inspect(saved_scratch))
      vim.cmd('tabn ' .. saved_scratch)
      return
    end
  end

  local get_name = function(number)
    return config.scratch_dir .. config.default_name .. current_buffer_ft .. number .. '.' .. current_buffer_extension
  end

  local scretch_num = 1
  local scretch_name = get_name(scretch_num)

  while vim.fn.filereadable(scretch_name) ~= 0 do
    scretch_num = scretch_num + 1
    scretch_name = get_name(scretch_num)
  end

  vim.api.nvim_command(config.split_cmd .. ' ' .. scretch_name)
  vim.bo.filetype = current_buffer_ft
  vim.cmd 'setlocal noswapfile buflisted bufhidden=hide'
  vim.cmd 'Codi'

  filetype_tabs[vim.bo.filetype] = vim.fn.tabpagenr()
end

-- creates a new named scratch file
local function new_named()
  fs.initDir(config.scratch_dir)

  local scretch_name = vim.fn.input 'Scratch name: '
  if scretch_name == '' then
    return
  end
  scretch_name = config.scratch_dir .. scretch_name
  vim.api.nvim_command(config.split_cmd .. ' ' .. scretch_name)
  vim.bo.filetype = fs.getFileTypeForExtension(strings.get_extension(scretch_name))
end

-- performs a fuzzy find across scratch files
local function search()
  local default_args = { cwd = config.scratch_dir }
  if config.backend == 'telescope.builtin' then
    local find_command

    if vim.fn.executable 'rg' == 1 then
      find_command = { 'rg', '--files', '--hidden', '-g', '*' }
    else
      find_command = { 'find', '.', '-type', 'f', '-not', '-path', '"./git/*"' }
    end

    -- require('telescope.builtin').find_files(vim.tbl_deep_extend('force', default_args, {
    --   prompt_title = 'Scratch Files',
    --   find_command = find_command,
    --   attach_mappings = function(prompt_bufnr, map)
    --     local action_state = require 'telescope.actions.state'
    --     map('i', '<CR>', function()
    --       local selection = action_state.get_selected_entry()
    --       require('telescope.actions').close(prompt_bufnr)
    --       local file = config.scratch_dir .. selection.value

    --       vim.api.nvim_command('edit ' .. file)
    --       vim.api.nvim_command 'Codi'
    --     end)

    --     return true
    --   end,
    -- }))

    Snacks.picker.files {
      cwd = config.scratch_dir,
      ignored = true,
      confirm = function(picker, item)
        picker:close()
        if item then
          -- dd(item)
          vim.schedule(function()
            vim.api.nvim_command('edit ' .. item._path)
            vim.api.nvim_command 'Codi'
          end)
        end
      end,
    }
  elseif config.backend == 'fzf-lua' then
    return require('fzf-lua').files(vim.tbl_deep_extend('force', default_args, {
      prompt = 'Scratch Files> ',
    }))
  end
end

local function get_grep_args(backend, query) end
-- performs a live grep across scratch files

local function grep(query)
  local default_args = { cwd = config.scratch_dir }
  if config.backend == 'telescope.builtin' then
    return require('telescope.builtin').live_grep(vim.tbl_deep_extend('force', default_args, {
      prompt_title = 'Scretch Search',
      search_dirs = { config.scratch_dir },
      live_grep_args = { '--hidden', '-g', '*', query },
    }))
  elseif config.backend == 'fzf-lua' then
    return require('fzf-lua').live_grep(vim.tbl_deep_extend('force', default_args, {
      prompt = 'Scretch Search>',
    }))
  end
end

-- opens the explorer in the scratch directory
local function explore()
  vim.api.nvim_command('edit ' .. config.scratch_dir)
end

-- returns the path of the most recently modified file in the given directory.
local function get_most_recent_file(dir)
  local most_recent_file
  local most_recent_modification_time = 0
  for _, file in ipairs(vim.fn.readdir(dir)) do
    local file_path = dir .. file
    if vim.fn.getftype(file_path) == 'file' then
      local modification_time = vim.loop.fs_stat(file_path).mtime.sec
      if modification_time > most_recent_modification_time then
        most_recent_file = file_path
        most_recent_modification_time = modification_time
      end
    end
  end
  return most_recent_file
end

-- opens the most recently modified scratch file.
local function last()
  local last_file = get_most_recent_file(config.scratch_dir)
  if not last_file then
    print 'No scretch file found.'
    return
  end
  local current_bufnr = vim.fn.bufnr ''
  local last_bufnr = vim.fn.bufnr(last_file)
  if current_bufnr == last_bufnr then
    vim.cmd 'hide'
  else
    vim.cmd(config.split_cmd .. ' ' .. last_file)
  end
end

local module = {
  new = new,
  new_named = new_named,
  last = last,
  search = search,
  grep = grep,
  setup = setup,
  explore = explore,
}

return module
