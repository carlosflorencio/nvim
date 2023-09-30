return {
  {
    -- package.json update actions, <leader>pv to change version
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    ft = "json",
    opts = {
      hide_up_to_date = true,
      hide_unstable_versions = true,
      colors = {
        up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
        outdated = "#d19a66", -- Text color for outdated dependency virtual text
      },
    },
    keys = {
      {
        "<leader>pv",
        "<cmd>lua require('package-info').change_version()<cr>",
        desc = "Package.json Change Version Dep",
      },
    },
  },

  {
    "delphinus/vim-firestore",
    ft = { "firestore" },
  },

  {
    -- jq / yq to json/yaml files, X query items under the cursor
    "gennaro-tedesco/nvim-jqx",
    -- ft = { "json", "yaml" },
    cmd = { "JqxList", "JqxQuery" },
  },

  {
    -- convert "${}" to `${}`
    "axelvc/template-string.nvim",
    -- event = "BufRead",
    ft = {
      "javascriptreact",
      "typescriptreact",
    },
    opts = {},
  },

  {
    -- rename react hooks args :RenameState
    "olrtg/nvim-rename-state",
    cmd = "RenameState",
    ft = {
      "typescriptreact",
      "javascriptreact",
    },
    keys = {
      { "<leader>lm", "<cmd>RenameState<cr>", desc = "Rename React Hooks args" },
    },
  },

  {
    "dmmulroy/tsc.nvim",
    dependencies = { "rcarriga/nvim-notify" },
    config = function()
      require("tsc").setup {
        -- flags = "--build",
      }
    end,
    cmd = { "TSC" },
  },
}
