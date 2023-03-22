local M = require("lualine.component"):extend()
local icons = require("user.ui").icons

function M:init(options)
  M.super.init(self, options)
end

function M:update_status()
  local buf_clients = vim.lsp.get_active_clients()
  local null_ls_installed, null_ls = pcall(require, "null-ls")
  local copilot_active = false
  local buf_client_names = {}
  for _, client in pairs(buf_clients) do
    if client.name == "null-ls" then
      if null_ls_installed then
        for _, kind in ipairs { "formatting", "diagnostics" } do
          for tool, tool_config in pairs(null_ls.builtins[kind]) do
            if vim.tbl_contains(tool_config.filetypes, vim.bo.filetype) or #tool_config.filetypes == 0 then
              if not buf_client_names[tool] then
                table.insert(buf_client_names, tool)
              end
            end
          end
        end
      end
    elseif client.name == "copilot" then
      copilot_active = true
    else
      table.insert(buf_client_names, client.name)
    end
  end

  local language_servers = "[" .. table.concat(buf_client_names, ", ") .. "]"

  if copilot_active then
    language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
  end

  return language_servers
end

return M
