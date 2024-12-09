local options = require("profiles.options")

require("config.vim")

if options.CURRENT_SYSTEM == options.System.Windows then
  require("config.powershell")
end

require("config.lazy")
require("config.lsp")
require("config.lint")
require("config.theme")
require('config.keymap')
