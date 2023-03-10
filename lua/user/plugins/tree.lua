local icons = require("user.ui").icons

return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            view = {
                width = {
                    min = 30,
                    max = 40
                },
                centralize_selection = true
            },
            renderer = {
                highlight_git = true,
                root_folder_label = ":t",
                highlight_opened_files = "all",
                symlink_destination = false,
                icons = {
                    glyphs = {
                        default = icons.ui.Text,
                        symlink = icons.ui.FileSymlink,
                        bookmark = icons.ui.BookMark,
                        folder = {
                            arrow_closed = icons.ui.TriangleShortArrowRight,
                            arrow_open = icons.ui.TriangleShortArrowDown,
                            default = icons.ui.Folder,
                            open = icons.ui.FolderOpen,
                            empty = icons.ui.EmptyFolder,
                            empty_open = icons.ui.EmptyFolderOpen,
                            symlink = icons.ui.FolderSymlink,
                            symlink_open = icons.ui.FolderOpen
                        },
                        git = {
                            unstaged = icons.git.FileUnstaged,
                            staged = icons.git.FileStaged,
                            unmerged = icons.git.FileUnmerged,
                            renamed = icons.git.FileRenamed,
                            untracked = icons.git.FileUntracked,
                            deleted = icons.git.FileDeleted,
                            ignored = icons.git.FileIgnored
                        }
                    }
                }
            },
            update_focused_file = {
                enable = true,
                debounce_delay = 15,
                update_root = true,
                ignore_list = {}
            },
            filters = {
                dotfiles = false,
                git_clean = false,
                no_buffer = false,
                custom = { "node_modules", "\\.cache" },
                exclude = {}
            },
            tab = {
                sync = {
                    open = true,
                    close = true,
                    ignore = {}
                }
            },
            git = {
                enable = true,
                ignore = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
                timeout = 200
            },
            trash = {
                cmd = "trash",
                require_confirm = true
            },
            diagnostics = {
                enable = true,
                show_on_dirs = false,
                show_on_open_dirs = true,
                debounce_delay = 50,
                severity = {
                    min = vim.diagnostic.severity.HINT,
                    max = vim.diagnostic.severity.ERROR
                },
                icons = {
                    hint = icons.diagnostics.BoldHint,
                    info = icons.diagnostics.BoldInformation,
                    warning = icons.diagnostics.BoldWarning,
                    error = icons.diagnostics.BoldError
                }
            }
        },
        cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" }
    },

    {
        -- when renaming files on nvim-tree, update imports through the LSP
        'antosha417/nvim-lsp-file-operations',
        dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-tree/nvim-tree.lua" } },
        opts = {}
    }
}
