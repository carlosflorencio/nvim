return {
  name = "tsc",
  builder = function()
    return {
      cmd = { "tsc" },
      components = {
        "default",
        { "on_output_parse", problem_matcher = "$tsc-watch" },
        "restart_on_save",
        "on_result_diagnostics",
        "on_result_diagnostics_quickfix",
      },
    }
  end,
  condition = {
    filetype = { "typescript", "typescriptreact" },
  },
}
