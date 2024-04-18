return {
          {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        globalstatus = true,
        icons_enabled = false,
        -- theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

}
