local current_path = vim.fn.stdpath("config")
package.path =
  current_path .. "/lua/libs/?.lua;" ..
  current_path .. "/lua/libs/?/init.lua;" ..
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
