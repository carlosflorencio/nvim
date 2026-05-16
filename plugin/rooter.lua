-- Worktree-aware replacement for nvim-rooter.
-- Uses vim.fs.root, which checks the source directory itself — so git
-- worktrees (whose `.git` is a file at the worktree root) resolve to the
-- worktree, not the parent repo.

local PATTERNS = { '.git', '.hg', '.svn' }
local EXCLUDE_FT = {
  help = true,
  nofile = true,
  dashboard = true,
  snacks_picker_input = true,
}

local group = vim.api.nvim_create_augroup('user_rooter', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  nested = true,
  callback = function(args)
    if EXCLUDE_FT[vim.bo[args.buf].filetype] then
      return
    end
    if vim.g.SessionLoad == 1 then
      return
    end

    local name = vim.api.nvim_buf_get_name(args.buf)
    local source = name ~= '' and name or vim.fn.getcwd()
    local root = vim.fs.root(source, PATTERNS)
    if root and root ~= vim.fn.getcwd() then
      vim.api.nvim_set_current_dir(root)
    end
  end,
})
