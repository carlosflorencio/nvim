return {{
    'kevinhwang91/nvim-bqf',
    ft = 'qf'
}, {
    -- past images from clipboard into md files :PasteImage
    "ekickx/clipboard-image.nvim",
    ft = {"markdown"},
    opts = {
        -- Default configuration for all filetype
        default = {
            -- ask for the image name before saving
            img_name = function()
                vim.fn.inputsave()
                local name = vim.fn.input('Name: ')
                vim.fn.inputrestore()

                if name == nil or name == '' then
                    return os.date('%y-%m-%d-%H-%M-%S')
                end
                return name
            end,

            -- %:p:h will get the directory of your current file. See also :help cmdline-special and :help filename-modifiers
            img_dir = {"%:p:h", "img"}
        }
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
    }
}, {
    "wakatime/vim-wakatime",
    lazy = false
}, {
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
                mappings = "<leader>gy"
            }
        }
    end
}, {
    -- "pwntester/octo.nvim",
    "NWVi/octo.nvim", -- todo: use original when local fs is merged
    branch = "config-review-use-local-fs",
    cmd = {"Octo"},
    dependencies = {'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'nvim-tree/nvim-web-devicons'},
    opts = {
        use_local_fs = true -- use local files on right side of reviews, enables LSP
    },
    keys = {{"<leader>op", "<cmd>Octo pr list<cr>", "Octo PR list"},
            {"<leader>or", "<cmd>Octo review resume<cr>", "Octo Review Resume"},
            {"<leader>os", "<cmd>Octo review submit<cr>", "Octo Review Submit"},
            {"<leader>oR", "<cmd>Octo review start<cr>", "Octo Review Start"},
            {"<leader>oD", "<cmd>Octo review discard<cr>", "Octo Review Discard"}}
}, {
    -- better macros, q, Q, cq (edit), ## breakpoint
    "chrisgrieser/nvim-recorder",
    opts = {
        -- Named registers where macros are saved. The first register is the default
        -- register/macro-slot used after startup.
        slots = {"a", "b"},

        -- default keymaps, see README for description what the commands do
        mapping = {
            startStopRecording = "q",
            playMacro = "Q",
            switchSlot = "<C-q>",
            editMacro = "cq",
            yankMacro = "yq", -- also decodes it for turning macros to mappings
            addBreakPoint = "##" -- ⚠️ this should be a string you don't use in insert mode during a macro
        },

        -- clears all macros-slots on startup
        clear = false,

        -- log level used for any notification, mostly relevant for nvim-notify
        -- (note that by default, nvim-notify does not show the levels trace and debug.)
        logLevel = vim.log.levels.INFO,

        -- experimental, see README
        dapSharedKeymaps = true
    },
    lazy = false
}  }
