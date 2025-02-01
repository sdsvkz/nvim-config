local options = require("profiles.options")
local profile = require("profiles")

require("config.vim")

if profile.preference.os == options.System.Windows then
  require("config.powershell")
end

require("config.lazy")
require("config.lsp")
require("config.lint")
require("config.dap")
require("config.theme")
require('config.keymap')
