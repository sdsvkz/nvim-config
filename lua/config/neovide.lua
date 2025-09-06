-- See https://neovide.dev/configuration.html
local profile = require("profiles")

local config = profile.preference.config_neovide
if config then
  config()
end
