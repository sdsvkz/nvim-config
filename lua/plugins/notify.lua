return {
  "rcarriga/nvim-notify",
  opts = {
    fps = 60,
    top_down = false,
  },
  init = function ()
    vim.opt.termguicolors = true
    vim.notify = require("notify")
  end,
}
