return {
  {
    -- Detect tabstop and shiftwidth automatically
    "nmac427/guess-indent.nvim",
    enabled = true,
    priority = 100,
    opts = {
      filetype_exclude = require("user.util.constants").disabled_filetypes,
    },
    lazy = false,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = true,
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
      local keymaps = {
        mode = { "n", "v" },
        ["g"] = {
          name = "+goto",
        },
        ["]"] = {
          name = "+next",
        },
        ["["] = {
          name = "+prev",
        },
        ["<leader>c"] = {
          name = "+close",
        },
        ["<leader>a"] = {
          name = "+AI",
        },
        ["<leader>l"] = {
          name = "+lsp",
        },
        ["<leader>f"] = {
          name = "+find/file",
        },
        ["<leader>g"] = {
          name = "+git",
        },
        ["<leader>gy"] = {
          name = "Github Link Yank",
        },

        ["<leader>gh"] = {
          name = "+hunks",
        },
        ["<leader>q"] = {
          name = "+quit/session",
        },
        ["<leader>s"] = {
          name = "+split",
        },
        ["<leader>t"] = {
          name = "+toggle",
        },
        ["<leader>d"] = {
          name = "+debug",
        },
        ["<leader>o"] = {
          name = "+organize/reviews",
        },
        ["<leader>h"] = {
          name = "+http",
        },
        [",b"] = {
          name = "+breakpoints",
        },
        [",t"] = {
          name = "+test",
        },
        [",o"] = {
          name = "+other file",
        },
      }
      wk.register(keymaps)
    end,
  },

  {
    -- improved marks, marks in signcolumn, cycle through marks
    "chentoast/marks.nvim",
    enabled = true,
    opts = {},
    lazy = false,
  },

  {
    -- Image asci previewer
    "samodostal/image.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    event = "BufReadPre",
  },

  {
    "rmagatti/auto-session",
    enabled = true,
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      auto_session_use_git_branch = true,
      pre_save_cmds = {
        -- "lua require('nvim-tree.api').tree.close_in_all_tabs()",
        "lua require('user.util.windows').close_all_floating_wins()",
        "lua require('user.util.windows').close_all_nvim_tree_buffers()",
      },
      -- post_restore_cmds = { "lua require('user.util.windows').close_tree_if_many_windows()" },
      -- post_restore_cmds = { "lua print('hello')", "lua print(require('nvim-tree.api').tree.is_visible())" },
      session_lens = {
        load_on_setup = false,
      },
    },
    lazy = false,
  },

  {
    -- generate docblocks
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      snippet_engine = "luasnip",
    },
    keys = {
      { "<leader>hc", '<cmd>lua require("neogen").generate()<cr>', desc = "Generate Comment Annotation" },
    },
  },

  {
    -- I dont don't to auto clear highlights
    -- I might be looking for certain words
    "asiryk/auto-hlsearch.nvim",
    enabled = false,
    version = "^1",
    event = "BufRead",
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    opts = {},
  },
  {
    -- auto close tags <div| => <div></div>
    "windwp/nvim-ts-autotag",
    opts = {},
    lazy = false,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup {
        -- labels = "asdfghjklqwertyuiopzxcvbn",
        search = {
          exclude = {
            "notify",
            "noice",
            "cmp_menu",
            "NvimTree",
            function(win)
              -- exclude non-focusable windows
              return not vim.api.nvim_win_get_config(win).focusable
            end,
          },
        },
        label = {
          -- uppercase = false,
          exclude = "S",
        },
        jump = {
          -- automatically jump when there is only one match
          autojump = true,
        },
        modes = {
          search = {
            enabled = false,
          },
          char = {
            enabled = false,
            keys = { "f", "F", ";", "," },
            jump_labels = true,
            highlight = { backdrop = false },
            -- search = { wrap = true },
            -- When using jump labels, don't use these keys
            -- This allows using those keys directly after the motion
            label = { exclude = "hjkliardcx" },
          },
        },
        remote_op = {
          -- restore window views and cursor position
          -- after doing a remote operation
          restore = true,
          -- For `jump.pos = "range"`, this setting is ignored.
          -- `true`: always enter a new motion when doing a remote operation
          -- `false`: use the window's cursor position and jump target
          -- `nil`: act as `true` for remote windows, `false` for the current window
          motion = true,
        },
      }
    end,
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
    },
  },

  {
    -- powerful search & replace
    "windwp/nvim-spectre",
    opts = {},
    keys = {
      {
        "<F3>",
        function()
          local path = vim.fn.fnameescape(vim.fn.expand "%:p:.")
          require("spectre").open_visual {
            select_word = true,
            path = path,
          }
        end,
        desc = "Replace in files (Spectre)",
      },
      {
        "<leader>sr",
        function()
          local path = vim.fn.fnameescape(vim.fn.expand "%:p:.")
          require("spectre").open_visual {
            select_word = true,
            path = path,
          }
        end,
        desc = "Replace in files (Spectre)",
      },
    },
  },
  {
    -- surround with selection highlight
    "kylechui/nvim-surround",
    opts = {},
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },
  {
    -- expand <C-a>/<C-x> toggles increments
    "nat-418/boole.nvim",
    opts = {
      mappings = {
        increment = "<C-a>",
        decrement = "<C-x>",
      },
    },
    event = "VeryLazy",
  },

  {
    -- edit fs as a buffer
    "elihunter173/dirbuf.nvim",
    cmd = { "Dirbuf" },
    keys = {
      { "<leader>'", "<cmd>Dirbuf<cr>", desc = "Dirbuf - edit fs as a buffer" },
    },
  },

  {
    "windwp/nvim-autopairs",
    enabled = true,
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
      enable_check_bracket_line = false,
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
  },

  -- comments
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  {
    "numToStr/Comment.nvim",
    opts = {
      ignore = "^$",
      pre_hook = function(...)
        local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
        if loaded and ts_comment then
          return ts_comment.create_pre_hook()(...)
        end
      end,
    },
    keys = {
      { "gc", mode = { "n", "v" } },
      { "gb", mode = { "n", "v" } },
      { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment toggle linewise (visual)", mode = "v" },
      { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment toggle current line" },
    },
    event = "User FileOpened",
  },

  -- better text-objects
  {
    "echasnovski/mini.ai",
    enabled = true,
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          -- line
          L = function(ai_type)
            local line_num = vim.fn.line "."
            local line = vim.fn.getline(line_num)
            -- Select `\n` past the line for `a` to delete it whole
            local from_col, to_col = 1, line:len() + 1
            if ai_type == "i" then
              if line:len() == 0 then
                -- Don't remove empty line
                from_col, to_col = 0, 0
              else
                -- Ignore indentation for `i` textobject and don't remove `\n` past the line
                from_col = line:match "^%s*()"
                to_col = line:len()
              end
            end

            return { from = { line = line_num, col = from_col }, to = { line = line_num, col = to_col } }
          end,
          -- buffer
          B = function(ai_type)
            local n_lines = vim.fn.line "$"
            local start_line, end_line = 1, n_lines
            if ai_type == "i" then
              -- Skip first and last blank lines for `i` textobject
              local first_nonblank, last_nonblank = vim.fn.nextnonblank(1), vim.fn.prevnonblank(n_lines)
              start_line = first_nonblank == 0 and 1 or first_nonblank
              end_line = last_nonblank == 0 and n_lines or last_nonblank
            end

            local to_col = math.max(vim.fn.getline(end_line):len(), 1)
            return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
          end,
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      if require("user.util").has "which-key.nvim" then
        ---@type table<string, string|table>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        local ic = vim.deepcopy(i)
        local ac = vim.deepcopy(a)
        for key, name in pairs { n = "Next", l = "Last" } do
          i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
          a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        end
        require("which-key").register {
          mode = { "o", "x" },
          i = i,
          a = a,
        }
      end
    end,
  },

  {
    "Wansmer/treesj",
    opts = { use_default_keymaps = false },
    keys = {
      { "<leader>hs", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
  },

  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    opts = {},
    keys = {
      {
        "<leader>ha",
        '<cmd>lua require("ts-node-action").node_action()<cr>',
        desc = "Toggle node action under cursor",
      },
    },
  },

  {
    -- yank ring
    "gbprod/yanky.nvim",
    opts = {
      ring = {
        history_length = 50,
        storage = "shada",
        sync_with_numbered_registers = true,
        cancel_event = "update",
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 100,
      },
      system_clipboard = {
        sync_with_ring = true,
      },
      preserve_cursor_position = {
        enabled = true,
      },
    },
    keys = {
      {
        "p",
        "<Plug>(YankyPutAfter)",
        desc = "Yanky put after",
        mode = { "n", "x" },
      },
      {
        "P",
        "<Plug>(YankyPutBefore)",
        desc = "Yanky put before",
        mode = { "n", "x" },
      },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
      { "]y", "<Plug>(YankyCycleBackward)", mode = "n" },
      { "[y", "<Plug>(YankyCycleForward)", mode = "n" },
      -- { "<c-v>", "<esc><cmd>Telescope yank_history initial_mode=normal<cr>", mode = { "n", "i", "v" } },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" } }, -- prevent going up when yanking
    },
  },

  {
    -- multi cursor a like, cmd - d
    "smoka7/multicursors.nvim",
    dependencies = {
      "smoka7/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<C-n>",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },

  {
    -- debug print variables
    "andrewferrier/debugprint.nvim",
    config = function()
      require("debugprint").setup {
        create_keymaps = false,
        move_to_debugline = true,
        print_tag = "here",
      }
    end,
  },

  {
    "rgroli/other.nvim",
    cmd = { "Other", "OtherVSplit", "OtherSplit" },
    config = function()
      local ts_alternative_targets = {
        { context = "source", target = "/%1/%2.%3" },
        { context = "test", target = "/%1/__tests__/%2.test.%3" },
        { context = "stories", target = "/%1/%2.stories.%3" },
      }

      require("other-nvim").setup {
        mappings = {
          -- builtin mappings
          -- "livewire",
          -- "angular",
          -- "laravel",
          -- "rails",
          "golang",
          -- typescript/javascript
          {
            pattern = "/(.*)/(.*).([jt]sx?)$",
            target = ts_alternative_targets,
          },
          -- Jest tests
          {
            pattern = "(.*)/__tests__/(.*).test.ts$",
            target = "%1/%2.ts",
            context = "implementation",
          },
        },
        keybindings = {
          ["<cr>"] = "open_file()",
          ["<esc>"] = "close_window()",
          o = "open_file()",
          q = "close_window()",
          v = "open_file_vs()",
          s = "open_file_vs()",
          h = "open_file_sp()",
          x = "open_file_sp()",
        },
      }
    end,
    keys = {
      { ",oo", "<cmd>Other<cr>", desc = "Open other file" },
      { ",ot", "<cmd>Other test<cr>", desc = "Open other test file" },
      { ",ov", "<cmd>OtherVSplit<cr>", desc = "Open other file vsplit" },
      { ",oh", "<cmd>OtherSplit<cr>", desc = "Open other file split" },
    },
  },

  {
    -- peek lines :number, <cr> to jump
    "nacro90/numb.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    -- better vim.o.undofile, keeps undo history
    -- when file is changed outside of vim
    "kevinhwang91/nvim-fundo",
    event = "BufReadPost",
    dependencies = "kevinhwang91/promise-async",
    build = function()
      require("fundo").install()
    end,
    opts = {},
  },

  {
    -- references underline word under the cursor
    "RRethy/vim-illuminate",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure {
        delay = 100,
        -- If nil, vim-illuminate will be disabled for large files.
        large_file_overrides = nil,
        filetypes_denylist = require("user.util.constants").disabled_filetypes,
      }

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },
}
