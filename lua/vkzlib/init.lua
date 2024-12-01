-- Lazy load everything into vkzlib.
local vkzlib = setmetatable({}, {
  __index = function(t, k)
    local ok, val = pcall(require, string.format("vkzlib.%s", k))

    if type(val) == "table" then

      if ok then
        rawset(t, k, val)
      end

      return val

    end
  end,
})

return vkzlib
