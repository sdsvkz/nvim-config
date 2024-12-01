local options = require("config.options")

---@type "OFF" | "ON"
_DEBUG = "OFF"

---@type vkzlib.logging.Logger.Level
LOG_LEVEL = "debug"

Vkzlib = require('vkzlib')
Plenary = require('plenary')

require("config.vim")

if options.CURRENT_SYSTEM == options.SYSTEM_LIST.WINDOWS then
  require("config.powershell")
end

---@diagnostic disable-next-line: different-requires
require("config.lazy")
require("config.lsp")
require("config.theme")
require('config.keymap')
require("config.autocmds")
