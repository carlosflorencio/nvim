return {
  -- {
  --   "kevinhwang91/nvim-bqf",
  --   ft = "qf",
  -- },

  {
    -- past images from clipboard into md files :PasteImage
    "ekickx/clipboard-image.nvim",
    ft = { "markdown" },
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
      -- -- You can create configuration for ceartain filetype by creating another field (markdown, in this case)
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
    "wakatime/vim-wakatime",
    lazy = false,
  },

  {
    -- generate github links
    "ruifm/gitlinker.nvim",
    event = "BufRead",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("gitlinker").setup {
        opts = {
          add_current_line_on_normal_mode = true,
          action_callback = require("gitlinker.actions").open_in_browser,
          print_url = true,
          mappings = "<leader>gy",
        },
      }
    end,
  },

  {
    -- "pwntester/octo.nvim",
    "NWVi/octo.nvim", -- todo: use original when local fs is merged
    branch = "config-review-use-local-fs",
    cmd = { "Octo" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
      use_local_fs = true, -- use local files on right side of reviews, enables LSP
    },
    keys = {
      { "<leader>op", "<cmd>Octo pr list<cr>", desc = "Octo PR list" },
      { "<leader>or", "<cmd>Octo review resume<cr>", desc = "Octo Review Resume" },
      { "<leader>os", "<cmd>Octo review submit<cr>", desc = "Octo Review Submit" },
      { "<leader>oR", "<cmd>Octo review start<cr>", desc = "Octo Review Start" },
      { "<leader>oD", "<cmd>Octo review discard<cr>", desc = "Octo Review Discard" },
    },
  },

  {
    -- better macros, q, Q, cq (edit), ## breakpoint
    "chrisgrieser/nvim-recorder",
    opts = {
      -- Named registers where macros are saved. The first register is the default
      -- register/macro-slot used after startup.
      slots = { "a", "b" },
      -- default keymaps, see README for description what the commands do
      mapping = {
        startStopRecording = "q",
        playMacro = "Q",
        switchSlot = "<C-q>",
        editMacro = "cq",
        yankMacro = "yq", -- also decodes it for turning macros to mappings
        addBreakPoint = "##", -- ⚠️ this should be a string you don't use in insert mode during a macro
      },
      -- clears all macros-slots on startup
      clear = false,
      -- log level used for any notification, mostly relevant for nvim-notify
      -- (note that by default, nvim-notify does not show the levels trace and debug.)
      logLevel = vim.log.levels.INFO,
      -- experimental, see README
      dapSharedKeymaps = true,
    },
    lazy = false,
  },

  {
    "tamago324/lir.nvim",
    config = function()
      local actions = require "lir.actions"
      local clipboard_actions = require "lir.clipboard.actions"
      require("lir").setup {
        devicons = {
          enable = true,
          highlight_dirname = true,
        },
        mappings = {
          ["h"] = actions.up,
          ["l"] = actions.edit,
          ["<CR>"] = actions.edit,
          ["<C-x>"] = actions.split,
          ["<C-s>"] = actions.split,
          ["s"] = actions.split,
          ["<C-v>"] = actions.vsplit,
          ["v"] = actions.vsplit,
          ["<C-t>"] = actions.tabedit,
          ["t"] = actions.tabedit,
          ["<esc>"] = actions.quit,
          ["q"] = actions.quit,
          ["a"] = actions.newfile,
          ["r"] = actions.rename,
          ["I"] = actions.toggle_show_hidden,
          ---@diagnostic disable-next-line: undefined-field
          ["c"] = clipboard_actions.yank_path,
          ["y"] = clipboard_actions.copy,
          ["x"] = clipboard_actions.cut,
          ["p"] = clipboard_actions.paste,
        },
        float = {
          winblend = 0,
          curdir_window = {
            enable = false,
            highlight_dirname = true,
          },
          -- You can define a function that returns a table to be passed as the third
          -- argument of nvim_open_win().
          ---@diagnostic disable-next-line: assign-type-mismatch
          win_opts = function()
            local width = math.floor(vim.o.columns * 0.5)
            local height = math.floor(vim.o.lines * 0.5)
            return {
              border = "rounded",
              width = width,
              height = height,
            }
          end,
        },
        hide_cursor = false,
      }

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "lir" },
        callback = function()
          -- use visual mode
          vim.api.nvim_buf_set_keymap(
            0,
            "x",
            "J",
            ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
            { noremap = true, silent = true }
          )
        end,
      })
    end,
    keys = {
      { "<leader>;", "<cmd>lua require'lir.float'.toggle()<cr>", desc = "Floating Lir" },
    },
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup {
        width = 150,
        plugins = {
          options = {
            enabled = false,
            ruler = true, -- disables the ruler text in the cmd line area
            showcmd = true, -- disables the command in the last line of the screen
          },
          gitsigns = { enabled = true }, -- disables git signs
        },
        on_close = function()
          vim.o.cmdheight = 0
          -- vim.cmd "set cc=80"
        end,
        on_open = function()
          vim.o.cmdheight = 1
          -- vim.cmd "set cc="
        end,
      }
    end,
    keys = {
      { "<leader>tt", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
  },

  {
    -- reminder to commit more frequently
    "redve-dev/neovim-git-reminder",
    dependencies = { "rcarriga/nvim-notify" },
    event = "BufRead",
    opts = {
      delay = 5,
      required_changes = 30,
      remind_on_save_only = true,
    },
  },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  {
    -- code screenshots
    "narutoxy/silicon.lua",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      font = "JetBrainsMono Nerd Font",
      padHoriz = 50, -- Horizontal padding
      padVert = 50, -- vertical padding
    },
    keys = {
      {
        "<leader>sp",
        function()
          require("silicon").visualise_api { to_clip = true }
        end,
        desc = "Silicon code screenshot",
        mode = "v",
      },
    },
  },

  {
    "LunarVim/bigfile.nvim",
    opts = {},
    event = { "FileReadPre", "BufReadPre", "User FileOpened" },
  },
}
