-- Lazy load everything into vkzlib.
local MODULE = "init"

local vkzlib = {
  core = require("vkzlib.core"),
  functional = require("vkzlib.functional"),
  internal = require("vkzlib.internal"),
  list = require("vkzlib.list"),
  logging = require("vkzlib.logging"),
  str = require("vkzlib.str"),
  table = require("vkzlib.table"),
  test = require("vkzlib.test"),
  typing = require("vkzlib.typing"),
  vim = require("vkzlib.vim"),
}

return vkzlib
