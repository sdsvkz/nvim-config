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

-- Setup storage

Vkz.storage = {
  path = vim.fn.stdpath("data") .. "/vkz/",
}

if vim.fn.isdirectory(Vkz.storage.path) == 0 then
  local code = vim.fn.mkdir(Vkz.storage.path, "p")
  if code == 0 then
    Vkz.log.e("Failed to create storage directory in: " .. Vkz.storage.path)
  end
end

-- Run config

require("config")
