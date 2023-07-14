return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require "null-ls"
      -- local disabled_filetypes = require("user.util.constants").disabled_filetypes
      -- local cspell_opts = {
      --   disabled_filetypes = disabled_filetypes,
      --   extra_args = { "--config", "~/.cspell.json" },
      --   diagnostics_postprocess = function(diagnostic)
      --     diagnostic.severity = vim.diagnostic.severity.INFO
      --   end,
      -- }
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),

        sources = {
          nls.builtins.formatting.fish_indent,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.prettierd,

          nls.builtins.diagnostics.fish,
          nls.builtins.diagnostics.actionlint,
          -- nls.builtins.diagnostics.cspell.with(cspell_opts),
          -- nls.builtins.diagnostics.proselint,
          nls.builtins.diagnostics.shellcheck.with {
            extra_args = { "--severity", "warning" },
          },

          -- require "typescript.extensions.null-ls.code-actions",
          -- nls.builtins.code_actions.cspell.with(cspell_opts),
          -- nls.builtins.code_actions.refactoring,
          -- nls.builtins.code_actions.gitsigns,
          nls.builtins.code_actions.shellcheck,
          -- nls.builtins.code_actions.proselint,
        },
      }
    end,
  },
}
