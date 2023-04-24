local M = {}

M.root_patterns = { ".git" }

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

function M.getShortenPath(path, n)
  local segments = {}
  for segment in path:gmatch "[^/]+" do
    table.insert(segments, segment)
  end
  local start_index = #segments - n + 1
  if start_index < 1 then
    start_index = 1
  end

  if start_index == 1 then
    return path
  end

  -- local shorten = vim.fn.pathshorten(table.concat(segments, "/", 1, start_index - 1))

  return "../" .. table.concat(segments, "/", start_index)
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require "lazy.core.plugin"
  return Plugin.values(plugin, "opts", false)
end

function M.edit_closest_file(filename)
  local match = vim.fs.find(filename, {
    upward = true,
    limit = 1,
    type = "file",
  })
  if #match > 0 then
    vim.cmd.edit(match[1])
  end
end

---Like lodash.get
---@param tbl table
---@param path string with path.dot.delimited
---@return any value in table at that path
function M.get(tbl, path)
  local parts = vim.split(path, ".", { plain = true })
  return vim.tbl_get(tbl, unpack(parts))
end

return M
