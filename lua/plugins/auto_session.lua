return {
  'rmagatti/auto-session',
  lazy = false,
  dependencies = {
    require("plugins.telescope"), -- Only needed if you want to use sesssion lens
  },
  config = function()
    require('auto-session').setup({
      auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    })
  end,
}
