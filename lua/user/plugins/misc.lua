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
}}
