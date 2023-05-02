local M = {}

-- https://github.com/metakirby5/codi.vim/wiki/Tips-%26-Tricks

-- vim.g["codi#width"] = 50.0
-- vim.g["codi#virtual_text"] = "0"

-- instead of destroying buffers, hide them and
-- index them by filetype into this dictionary
local codi_filetype_tabs = {}

function M.FullscreenScratch()
  -- store filetype and bufnr of current buffer
  -- for later reference
  local current_buf_ft = vim.bo.filetype
  local current_buf_num = vim.fn.bufnr "%"

  -- check if a scratch buffer for this filetype already exists
  local saved_scratch = codi_filetype_tabs[current_buf_ft] or -1

  -- if a tabpage exists for current_buf_ft, go to it instead of
  -- creating a new scratch buffer
  if saved_scratch ~= -1 then
    if vim.fn.index(vim.fn.map(vim.fn.gettabinfo(), "v:val.tabnr"), saved_scratch) == -1 then
      codi_filetype_tabs[current_buf_ft] = nil
    else
      vim.cmd("tabn " .. saved_scratch)
      return
    end
  end

  -- create a new empty tab, set scratch options and give it a name
  vim.cmd "tabe"
  vim.cmd "setlocal buftype=nofile noswapfile modifiable buflisted bufhidden=hide"
  vim.cmd(":file scratch::" .. current_buf_ft)

  -- set filetype to that of original source file
  -- e.g. ruby / python / w/e Codi supports
  vim.bo.filetype = current_buf_ft

  -- store the tabpagenr per filetype so we can return
  -- to it later when re-opening from the same filetype
  codi_filetype_tabs[vim.bo.filetype] = vim.fn.tabpagenr()

  -- create a buffer local mapping that overrides the
  -- outer one to delete the current scratch buffer instead
  -- when the buffer is destroyed, this mapping will be
  -- destroyed with it and the next <Leader><Leader>
  -- will spawn a new fullscreen scratch window again
  -- vim.api.nvim_buf_set_keymap(0, "n", "<Leader><Leader>", ":tabprevious<CR>", { silent = true, noremap = true })

  -- everything is setup, filetype is set
  -- let Codi do the rest :)
  vim.cmd "Codi"
end

return M
