---For override setting
---@type boolean, vkzlib.options.Options
local ok, user_options = pcall(require, "vkzlib.user")

user_options = ok and type(user_options) == "table" and user_options or {}

---@class vkzlib.options.Options
local options = {
  ---Whether enable test module of `vkzlib`
  ---@type boolean
  enable_test = user_options.enable_test or false,

  ---Name of test modules to run on requiring the library
  ---@type string[]
  run_test = user_options.run_test or {},

  ---Log level for `vkzlib.logging`
  ---@type vkzlib.logging.Logger.Level
  log_level = user_options.log_level or "info",
}

return options
