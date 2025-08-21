-- Eagerly load everything into vkzlib.
local options = require("vkzlib.options")

local vkzlib = {
  options = options,
  core = require("vkzlib.core"),
  Data = require("vkzlib.Data"),
  functional = require("vkzlib.functional"),
  io = require("vkzlib.io"),
  logging = require("vkzlib.logging"),
  typing = require("vkzlib.typing"),
  vim = require("vkzlib.vim"),
}

if options.enable_test then
  vkzlib.test = require("vkzlib.test")
end

return vkzlib
