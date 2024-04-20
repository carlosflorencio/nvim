return {
  {
    'rcarriga/nvim-notify',
    priority = 100, -- set notify first than other plugins
    enabled = true,
    opts = {
      timeout = 1000,
      fps = 60,
      render = 'minimal',
    },
    config = function(_, opts)
      local notify = require 'notify'
      notify.setup(opts)

      vim.notify = notify
    end,
  },
}
