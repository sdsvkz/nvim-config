local profile = require("profiles")
local config = profile.appearence.theme.config

local vkzlib = Vkz.vkzlib

local themes = vkzlib.data.table.map(function (spec)
  spec.config = type(config) == "function" and config(spec.main) or config
  return spec
end, {
  require("plugins.themes.fluoromachine"),
  require("plugins.themes.night_owl"),
  require("plugins.themes.tokyonight"),
  require("plugins.themes.moonfly"),
  require("plugins.themes.catppuccin"),
})

return themes
