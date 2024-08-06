---@type "OFF" | "ON" | "VERBOSE"
_DEBUG = "ON"

function Log(...)
  if _DEBUG == "ON" then vim.print(...) end
end

function VLog(...)
  if _DEBUG == "VERBOSE" then vim.print(...) end
end

Vkzlib = require("config.vkzlib")
require("config.vim")

local options = require("config.options")
if options.CURRENT_SYSTEM == options.SYSTEM_LIST.WINDOWS then
  require("config.powershell")
end

---@diagnostic disable-next-line: different-requires
require("config.lazy")
require("config.lsp")
require("config.theme")
require('config.keymap')
