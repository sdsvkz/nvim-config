-- Lazily loaded vkzlib.
local options = require("vkzlib.options")

local vkzlib = setmetatable({
  options = options
}, {
  __index = function(t, k)
    -- Exclude
    if k == "init" or k == "lazy" or k == "user" then
      return nil
    end

    local path = k == "_test" and options.enable_test == true and "test" or string.format("vkzlib.%s", k)

    local ok, val = pcall(require, path)

    if not ok or type(val) == "table" then
      return nil
    end

    -- Loaded and not ignored
    rawset(t, k, val)
    return val
  end
})

return vkzlib
