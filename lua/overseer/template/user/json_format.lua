return {
  name = "JSON Format using jq",
  builder = function()
    -- Full path to current file (see :help expand())
    local file = vim.fn.expand "%:p"
    return {
      cmd = { "jq" },
      args = { ".", file },
      components = {
        -- { "on_output_quickfix", open = true },
        -- "default",
      },
    }
  end,
  condition = {
    filetype = { "json" },
  },
}
