return {
  {
    -- ctrl-n to select next word
    --  n to select next word
    --  q to skip word
    --  ] move to the next cursor
    --  tab to toggle between visual and normal mode
    -- ctrl-down/up to add cursor below/above (mod - d - down)
    -- inside normal mode, s operator to select word
    -- leader is \\ (+A to select all words)
    -- https://github.com/mg979/vim-visual-multi/wiki/Mappings#buffer-mappings
    'mg979/vim-visual-multi',
    event = 'VeryLazy',
    init = function()
      vim.g.VM_silent_exit = 1
      vim.g.VM_quit_after_leaving_insert_mode = 1
      vim.g.VM_leader = { default = ',', visual = ',', buffer = ',' }
    end,
  },
}
