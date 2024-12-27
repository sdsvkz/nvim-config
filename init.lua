local current_path = vim.fn.stdpath("config")
package.path =
  current_path .. "/lua/libs/?.lua;" ..
  current_path .. "/lua/libs/?/init.lua;" ..
  package.path

-- luacheck: ignore
Vkzlib = require("vkzlib")

require("config")

-- Function = Vkzlib.functional.Function
-- F = function(x, y, z)
--   print(vim.inspect({ x = x, y = y, z = z }))
-- end

