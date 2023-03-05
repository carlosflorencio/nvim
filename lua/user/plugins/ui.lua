local function is_ft(b, ft)
    return vim.bo[b].filetype == ft
end

local function custom_filter(buf, buf_nums)
    local logs = vim.tbl_filter(function(b)
        return is_ft(b, "log")
    end, buf_nums or {})
    if vim.tbl_isempty(logs) then
        return true
    end
    local tab_num = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr "$"
    local is_log = is_ft(buf, "log")
    if last_tab == 1 then
        return true
    end
    -- only show log buffers in secondary tabs
    return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

return {{
    "rcarriga/nvim-notify",
    opts = {
        timeout = 3000,
        render = "minimal"
    },
    keys = {{
        "<leader>un",
        function()
            require("notify").dismiss({
                silent = true,
                pending = true
            })
        end,
        desc = "Delete all Notifications"
    }}
}, -- better vim.ui
{
    "stevearc/dressing.nvim",
    opts = {
        select = {
            get_config = function(opts)
                -- https://github.com/stevearc/dressing.nvim/issues/22#issuecomment-1067211863
                -- for codeaction, we want null-ls to be last
                -- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/630
                if opts.kind == 'codeaction' then
                    return {
                        telescope = {
                            -- sorter = require 'telescope.sorters'.Sorter:new {
                            --   scoring_function = function(_, _, line)
                            --     if string.match(line, 'null-ls') then
                            --       return 1
                            --     else
                            --       return 0
                            --     end
                            --   end,
                            -- },
                            initial_mode = "normal",
                            -- copied from the telescope dropdown theme
                            sorting_strategy = "ascending",
                            layout_strategy = "center",
                            layout_config = {
                                preview_cutoff = 1, -- Preview should always show (unless previewer = false)
                                width = 80,
                                height = 15
                            },
                            borderchars = {
                                prompt = {"─", "│", " ", "│", "╭", "╮", "│", "│"},
                                results = {"─", "│", "─", "│", "├", "┤", "╯", "╰"},
                                preview = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"}
                            }
                        }
                    }
                end
            end
        }
    },
    init = function()
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
            require("lazy").load({
                plugins = {"dressing.nvim"}
            })
            return vim.ui.select(...)
        end
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.input = function(...)
            require("lazy").load({
                plugins = {"dressing.nvim"}
            })
            return vim.ui.input(...)
        end
    end
}, -- bufferline
{
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {{
        "<S-l>",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next Tab"
    }, {
        "<S-h>",
        "<cmd>BufferLineCyclePrev<cr>",
        desc = "Previous Tab"
    }},
    opts = {
        options = {
            truncate_names = false,
            mode = "tabs",
            sort_by = "tabs",
            show_tab_indicators = false,
            always_show_bufferline = true,
            show_buffer_close_icons = false,
            separator_style = "thick",
            custom_filter = custom_filter,
            indicator = {
                icon = ""
            },
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(_, _, diag)
                local icons = require("user.ui").lsp_diagnostic_icons
                local ret = (diag.error and icons.Error .. diag.error .. " " or "") ..
                                (diag.warning and icons.Warn .. diag.warning or "")
                return vim.trim(ret)
            end,
            offsets = {{
                filetype = "undotree",
                text = "Undotree",
                highlight = "PanelHeading",
                padding = 1
            }, {
                filetype = "NvimTree",
                -- text = "Explorer",
                text = "",
                -- highlight = "PanelHeading",
                padding = 0
            }, {
                filetype = "DiffviewFiles",
                text = "Diff View",
                highlight = "PanelHeading",
                padding = 1
            }, {
                filetype = "flutterToolsOutline",
                text = "Flutter Outline",
                highlight = "PanelHeading"
            }, {
                filetype = "lazy",
                text = "Lazy",
                highlight = "PanelHeading",
                padding = 1
            }}
        }
    }
}, {
    -- show colorcolumn when line is too long
    "m4xshen/smartcolumn.nvim",
    opts = {
        limit_to_window = true
    },
    lazy = false
},
{
    -- expand windows
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      -- "anuvyklack/animation.nvim"
    },
    opts = { },
    cmd = {"WindowsMaximize", "WindowsEqualize", "WindowsToggleAutowidth"}
  },

  {
    "petertriho/nvim-scrollbar",
    opts = {
        excluded_filetypes = {
            "prompt",
            "TelescopePrompt",
            "noice",
            "NvimTree"
          }
    },
    lazy = false
  }

}
