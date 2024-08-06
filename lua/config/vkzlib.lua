local M = {
  functional = require("vkzlib.functional"),
  list = require("vkzlib.list"),
  str = require("vkzlib.str"),
  table = require("vkzlib.table"),
  vim = require("vkzlib.vim"),
}

if _DEBUG then
  M.test = require("vkzlib.test")
end

return M
