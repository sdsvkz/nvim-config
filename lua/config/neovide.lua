-- See https://neovide.dev/configuration.html
local profile = require("profiles")

if vim.g.neovide then
  local config = profile.preference.config_neovide
  if config then
    config()
  end
end
