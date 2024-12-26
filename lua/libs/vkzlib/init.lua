-- Eagerly load everything into vkzlib.
local options = require("vkzlib.options")

local vkzlib = {
  options = options,
  core = require("vkzlib.core"),
  functional = require("vkzlib.functional"),
  internal = require("vkzlib.internal"),
  list = require("vkzlib.list"),
  logging = require("vkzlib.logging"),
  str = require("vkzlib.str"),
  table = require("vkzlib.table"),
  typing = require("vkzlib.typing"),
  vim = require("vkzlib.vim"),
}

if options.enable_test then
  vkzlib.test = require("vkzlib.test")
end

return vkzlib
