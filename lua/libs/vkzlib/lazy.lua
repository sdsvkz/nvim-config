-- Lazily loaded vkzlib.
local options = require("vkzlib.options")

local vkzlib = setmetatable({
  options = options
}, {
  __index = function(t, k)
    -- Exclude
    if k == "init" or k == "lazy" or k == "user" or (k == "test" and options.enable_test == false) then
      return nil
    end

    local ok, val = pcall(require, string.format("vkzlib.%s", k))

    if not ok or type(val) == "table" then
      return nil
    end

    -- Loaded and not ignored
    rawset(t, k, val)
    return val
  end
})

return vkzlib
