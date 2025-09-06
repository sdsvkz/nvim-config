local options = require("profiles.options")
local profile = require("profiles")

require("config.vim")

if profile.preference.os == options.System.Windows then
  require("config.powershell")
end

if vim.g.neovide then
  require("config.neovide")
end

require("config.lazy")
require("config.lsp")
require("config.lint")
require("config.dap")

if profile.preference.use_mason == true then
  require("config.mason")
end

if profile.preference.use_ai == true then
  require("config.ai")
end

require("config.theme")
require('config.keymap')
