return {
  {
    -- package.json update actions, <leader>pv to change version
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
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
    -- scratch files
    "metakirby5/codi.vim",
    cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand" },
  },

  {
    "delphinus/vim-firestore",
    ft = { "firestore" },
  },

  {
    -- preview markdown, glow needs to be installed globally
    "npxbr/glow.nvim",
    ft = { "markdown" },
    opts = {
      width_ratio = 0.8, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
      height_ratio = 0.8,
    },
    keys = {
      { "<leader>pp", "<cmd>Glow<cr>", desc = "Glow Markdown Preview" },
    },
  },

  {
    "rest-nvim/rest.nvim",
    ft = { "http" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- Open request results in a horizontal split
      result_split_horizontal = false,
      -- Keep the http file buffer above|left when split horizontal|vertical
      result_split_in_place = false,
      -- Skip SSL verification, useful for unknown certificates
      skip_ssl_verification = false,
      -- Encode URL before making request
      encode_url = true,
      -- Highlight request on run
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        -- toggle showing URL, HTTP info, headers at top the of result window
        show_url = true,
        show_http_info = true,
        show_headers = true,
        -- executables or functions for formatting response body [optional]
        -- set them to false if you want to disable them
        formatters = {
          json = "jq",
          html = false,
        },
      },
      -- Jump to request line on run
      jump_to_request = false,
      env_file = ".env",
      custom_dynamic_variables = {},
      yank_dry_run = true,
    },
    keys = {

      { "<leader>hh", "<Plug>RestNvim", desc = "Run request under cursor" },
      { "<leader>hp", "<Plug>RestNvimPreview", desc = "Preview the curl command under cursor" },
      { "<leader>hl", "<Plug>RestNvimLast", desc = "Run last http request" },
    },
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
    event = "BufRead",
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
}
