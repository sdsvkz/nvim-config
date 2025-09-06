local profile = require("profiles")

---@type notify.Config
---@diagnostic disable-next-line: missing-fields
local opts = {
  background_colour = "#000000",
  fps = 60,
  level = profile.debugging.log_level,
  top_down = false,
}

---@type LazyPluginSpec
return {
  "rcarriga/nvim-notify",
  opts = profile.utils.merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
  lazy = false,
  priority = 114514,
  init = function ()
    vim.opt.termguicolors = true
    vim.notify = require("notify")
  end,
}
