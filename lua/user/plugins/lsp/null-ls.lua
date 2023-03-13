return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require "null-ls"
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.fish_indent,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,

          nls.builtins.diagnostics.fish,
          nls.builtins.diagnostics.actionlint,
          nls.builtins.diagnostics.codespell,
          nls.builtins.diagnostics.proselint,
          nls.builtins.diagnostics.shellcheck.with {
            extra_args = { "--severity", "warning" },
          },

          nls.builtins.code_actions.gitsigns,
          nls.builtins.code_actions.refactoring,
          nls.builtins.code_actions.shellcheck,
          nls.builtins.code_actions.proselint,
        },
      }
    end,
  },
}
