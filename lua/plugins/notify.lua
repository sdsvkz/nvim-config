local profile = require("profiles")

---@type LazyPluginSpec
return {
  "rcarriga/nvim-notify",
  ---@type notify.Config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    background_colour = "#000000",
    fps = 60,
    level = profile.debugging.log_level,
    top_down = false,
  },
  lazy = false,
  priority = 114514,
  init = function ()
    vim.opt.termguicolors = true
    vim.notify = require("notify")
  end,
}
