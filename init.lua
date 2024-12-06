---@type "OFF" | "ON"
_DEBUG = "ON"

---@type vkzlib.logging.Logger.Level
LOG_LEVEL = "debug"

local options = require("config.options")

Vkzlib = require("vkzlib")
Plenary = require("plenary")
Luassert = require("luassert")

Function = Vkzlib.functional.Function
F = function(x, y, z)
  print(vim.inspect({ x = x, y = y, z = z }))
end

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
