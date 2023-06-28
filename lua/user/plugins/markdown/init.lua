return {

  {
    -- floating notes
    "JellyApple102/flote.nvim",
    config = function()
      require("flote").setup {
        window_border = "single",
        window_style = "minimal",
        window_title = true,
        notes_dir = "~/Notes/Projects",
        files = {
          global = "global.md",
          cwd = function()
            local bufPath = vim.api.nvim_buf_get_name(0)
            local cwd = require("lspconfig").util.root_pattern ".git"(bufPath)

            vim.notify(cwd)
            return cwd
          end,
        },
      }
    end,
    keys = {
      { "<leader>pn", "<cmd>Flote<CR>", desc = "Project Notes" },
    },
  },

  {
    -- <c-space> turn list item into todo
    -- :MkdnTable 2 2, :MkdnTableFormat
    --
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown" },
    config = function()
      require("mkdnflow").setup {
        mappings = {
          -- MkdnNewListItem = { "i", "<CR>" },
          MkdnEnter = { { "i", "n", "v" }, "<CR>" },
          MkdnFoldSection = { "n", "<leader>z" },
          MkdnUnfoldSection = { "n", "<leader>Z" },
          MkdnTableNewRowBelow = { "n", "<leader>nr" },
          MkdnTableNewRowAbove = { "n", "<leader>nR" },
          MkdnTableNewColAfter = { "n", "<leader>nc" },
          MkdnTableNewColBefore = { "n", "<leader>nC" },
        },
        table = {
          auto_extend_rows = true,
        },
      }
    end,
  },

  -- Background highlights for headers
  -- disabled - too slow
  {
    lazy = false,
    enabled = false,
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("headlines").setup {
        markdown = {
          query = vim.treesitter.query.parse(
            "markdown",
            [[
                (atx_heading [
                    (atx_h1_marker)
                    (atx_h2_marker)
                    (atx_h3_marker)
                    (atx_h4_marker)
                    (atx_h5_marker)
                    (atx_h6_marker)
                ] @headline)

                (thematic_break) @dash
            ]]
          ),
          codeblock_highlight = "",
          fat_headlines = true,
          fat_headline_upper_string = "▁",
          fat_headline_lower_string = "▔",
        },
      }
      vim.cmd [[highlight Headline guibg=#212630]]
    end,
  },

  {
    -- past images from clipboard into md files :PasteImage
    -- "ekickx/clipboard-image.nvim", todo: re-enable after health fix
    "postfen/clipboard-image.nvim",
    cmd = "PasteImg",
    opts = {
      -- Default configuration for all filetype
      default = {
        -- ask for the image name before saving
        img_name = function()
          vim.fn.inputsave()
          local name = vim.fn.input "Name: "
          vim.fn.inputrestore()

          if name == nil or name == "" then
            return os.date "%y-%m-%d-%H-%M-%S"
          end
          return name
        end,
        -- %:p:h will get the directory of your current file. See also :help cmdline-special and :help filename-modifiers
        img_dir = { "%:p:h", "img" },
      },
      -- -- You can create configuration for certain filetype by creating another field (markdown, in this case)
      -- -- If you're uncertain what to name your field to, you can run `lua print(vim.bo.filetype)`
      -- -- Missing options from `markdown` field will be replaced by options from `default` field
      -- markdown = {
      --   img_dir = { "src", "assets", "img" }, -- Use table for nested dir (New feature form PR #20)
      --   img_dir_txt = "/assets/img",
      --   img_handler = function(img) -- New feature from PR #22
      --     local script = string.format('./image_compressor.sh "%s"', img.path)
      --     os.execute(script)
      --   end,
      -- }
    },
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
}
