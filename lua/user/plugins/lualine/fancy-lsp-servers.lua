local M = require('lualine.component'):extend()

function M:init(options)
  options.icon = options.icon or '󰌘'
  options.split = options.split or ', '
  M.super.init(self, options)
end

function M:update_status()
  local buf_clients = vim.lsp.get_clients()
  local null_ls_installed, null_ls = pcall(require, 'null-ls')
  local buf_client_names = {}
  local seen = {}

  for _, client in pairs(buf_clients) do
    if client.name == 'null-ls' then
      if null_ls_installed then
        for _, source in ipairs(null_ls.get_source { filetype = vim.bo.filetype }) do
          if not seen[source.name] then
            table.insert(buf_client_names, source.name)
            seen[source.name] = true
          end
        end
      end
    else
      local name = client.name == 'GitHub Copilot' and 'Copilot' or client.name
      if not seen[name] then
        table.insert(buf_client_names, name)
        seen[name] = true
      end
    end
  end

  return table.concat(buf_client_names, self.options.split)
end

return M
