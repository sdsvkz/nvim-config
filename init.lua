local current_path = vim.fn.stdpath("config")
package.path =
  current_path .. "/lua/libs/?.lua;" ..
  current_path .. "/lua/libs/?/init.lua;" ..
  package.path

local vkzlib = require("vkzlib")

Vkz = {}
Vkz.vkzlib = vkzlib
Vkz.log = {
  t = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
    print = print,
    level = "trace",
    with_traceback = true,
  }),
  d = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
    print = print,
    level = "debug",
    with_traceback = true,
  }),
  i = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
    print = print,
    level = "info",
  }),
  w = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
    print = print,
    level = "warn"
  }),
  e = vkzlib.logging.get_logger(vkzlib.logging.default_format, {
    print = print,
    level = "error"
  }),
}

Vkz.storage = {
  path = vim.fn.stdpath("data") .. "/vkz/",
}

require("config")
