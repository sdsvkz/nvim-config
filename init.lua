Utils = require("config.utils")
require("config.vim")

local options = require("config.options")

if options.CURRENT_SYSTEM == options.SYSTEM_LIST.WINDOWS then
  require("config.powershell")
end

require("config.lazy")
require("config.lsp")
require("config.theme")
require('config.keymap')
