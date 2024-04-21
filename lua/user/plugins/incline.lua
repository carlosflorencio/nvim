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
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end

          local modified_icon = vim.bo[props.buf].modified and '! ' or ''

          return {
            { modified_icon, guibg = 'none' },
            { filename .. ' ', gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold', group = get_diagnostic_label(props) },
          }
        end,
      }
    end,
    event = 'VeryLazy',
  },
}
