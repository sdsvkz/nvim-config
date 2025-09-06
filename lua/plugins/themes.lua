local profile = require("profiles")
local plugin = profile.appearence.theme.plugin
local config = profile.appearence.theme.config

if type(plugin) == "table" then
  return plugin
elseif plugin == nil then
  return {}
end

---@type LazyPluginSpec
local theme = require("plugins.themes." .. plugin)
theme.config = type(config) == "function" and config(theme.main) or config

return theme
