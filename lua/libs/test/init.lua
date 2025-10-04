---@class Test.vkzlib.Module
---@field tests table<string, Test.vkzlib.Module.Component>

---@class Test.vkzlib.Module.Component
---@field test fun()

local options = require("vkzlib.options")
local internal = require("vkzlib.internal")

local log = {
  w = internal.logger("test", "warn")
}

-- Run tests

local MODULES = {}

for _, MODULE_NAME in ipairs(options.run_test) do
  local PATH = string.format("test.%s", MODULE_NAME)
  local ok, MODULE = pcall(require, string.format("test.%s", MODULE_NAME))
  if not ok then
    log.w("Run Tests", string.format("Test module not exists: %s", MODULE_NAME))
    goto continue
  end
  local TESTS = type(MODULE) == "table" and type(MODULE.tests) == "table" and MODULE.tests or nil
  if not TESTS then
    log.w("Run Tests", string.format("`test.%s` is not a proper test module", MODULE_NAME))
    goto continue
  end
  MODULES[PATH] = TESTS
    ::continue::
end

for PATH, MODULE in pairs(MODULES) do
  for COMPONENT_NAME, COMPONENT in pairs(MODULE) do
    if COMPONENT.test and type(COMPONENT.test) == "function" and debug.getinfo(COMPONENT.test).nparams == 0 then
      COMPONENT.test()
    else
      log.w("Run Tests", string.format("%s.%s doesn't contain any test", PATH, COMPONENT_NAME))
    end
  end
end

local M = {
  functional = require("test.functional"),
  Data = {
    list = require("test.Data.list"),
    table = require("test.Data.table"),
  },
}

return M

