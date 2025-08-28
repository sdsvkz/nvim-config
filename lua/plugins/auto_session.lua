local Groups = require("config.key_groups").Groups

return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '/', [[C:\Users\*]] },
    bypass_save_filetypes = { 'alpha', 'dashboard' },
    -- log_level = 'debug',
  },
  init = function ()
    vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
  end,
  keys = {
    {
      Groups.UI.lhs .. "s", mode = "n",
      "<CMD>AutoSession search<CR>",
      desc = "Search for sessions"
    },
  },
}
