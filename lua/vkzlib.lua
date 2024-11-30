local vkzlib = {
  core = require("vkzlib.core"),
  functional = require("vkzlib.functional"),
  list = require("vkzlib.list"),
  str = require("vkzlib.str"),
  table = require("vkzlib.table"),
  typing = require("vkzlib.typing"),
  vim = require("vkzlib.vim"),
  logging = require("vkzlib.logging"),
}

if _DEBUG then
  vkzlib.test = require("vkzlib.test")
end

return vkzlib
