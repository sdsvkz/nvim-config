-- Lazy load everything into vkzlib.
local MODULE = "lazy"

local profile = require("profiles")

local vkzlib = setmetatable({}, {
  __index = function(t, k)
    if k == "init" or k == "lazy" then
      return nil
    end

    local ok, val = pcall(require, string.format("vkzlib.%s", k))

    if ok and type(val) == "table" then
      -- Loaded and not ignored
      rawset(t, k, val)
    elseif profile.debugging.enable_test == false and not ok then
      -- Failed to load or tried to load test module when test disabled
      local log = {
        d = require("vkzlib.internal").logger(MODULE, "debug")
      }
      local core = require("vkzlib.core")
      assert(type(core) == "table", "vkzlib.init: Unable to load core for printing error object")
      log.d("vkzlib.<metatable>.__index", core.to_string(val))
    end
    -- ok == true and val == nil ignored

    return val
  end
})

return vkzlib
