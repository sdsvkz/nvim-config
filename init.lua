local current_path = vim.fn.stdpath("config")
package.path =
  current_path .. "/lua/libs/?.lua;" ..
  current_path .. "/lua/libs/?/init.lua;" ..
  package.path

-- luacheck: ignore
Vkzlib = require("vkzlib")
-- luacheck: ignore
Log = {
  t = Vkzlib.logging.get_logger(Vkzlib.logging.default_format, {
    print = print,
    level = "trace",
    with_traceback = true,
  }),
  d = Vkzlib.logging.get_logger(Vkzlib.logging.default_format, {
    print = print,
    level = "debug",
    with_traceback = true,
  }),
  i = Vkzlib.logging.get_logger(Vkzlib.logging.default_format, {
    print = print,
    level = "info",
  }),
}

require("config")
