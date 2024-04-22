return {
  {
    'b0o/incline.nvim',
    config = function()
      local function get_diagnostic_label(props)
        local severity = { 'error', 'warn', 'info', 'hint' }
        for _, type in ipairs(severity) do
          local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(type)] })
          if n > 0 then
            return 'DiagnosticSign' .. type
          end
        end
        return nil
      end

      require('incline').setup {
        window = {
          padding = {
            left = 1,
            right = 0,
          },
          margin = {
            horizontal = 0,
            vertical = 0,
          },
        },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end

          local modified_icon = vim.bo[props.buf].modified and '󰏫 ' or ''

          -- if there are at least 2 tabs, hide
          if #vim.api.nvim_list_tabpages() > 1 then
            return {}
          end

          return {
            { modified_icon, guibg = 'none', guifg = 'red' },
            { filename .. ' ', gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold', group = get_diagnostic_label(props) },
          }
        end,
      }
    end,
    event = 'VeryLazy',
  },
}
