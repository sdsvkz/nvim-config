local current_path = debug.getinfo(1, "S").source:sub(2)
current_path = current_path:sub(1, #current_path - #"init.lua")
package.path =
  current_path .. "lua/libs/?.lua;" ..
  current_path .. "lua/libs/?/init.lua;" ..
  package.path

---@type "OFF" | "ON"
_DEBUG = "OFF"

---@type vkzlib.logging.Logger.Level
LOG_LEVEL = "debug"

Vkzlib = require("vkzlib")
Plenary = require("plenary")
Luassert = require("luassert")

-- Function = Vkzlib.functional.Function
-- F = function(x, y, z)
--   print(vim.inspect({ x = x, y = y, z = z }))
-- end

require("config")
