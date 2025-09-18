local MODULE = "core"

local core = require('vkzlib.internal').core

---Return the first value that is not nil
---@generic T
---@param ... T
---@return T?
local function first_not_nil(...)
  for i = 1, select("#", ...) do
    local x = select(i, ...)
    if x ~= nil then
      return x
    end
  end
end

return {
  all = core.all,
  also = core.also,
  any = core.any,
  assert = core.assert,
  conditional = core.conditional,
  deep_copy = core.deep_copy,
  enable_if = core.enable_if,
  equals = core.equals,
  from_maybe = core.from_maybe,
  from_type  = core.from_type,
  first_not_nil = first_not_nil,
  let = core.let,
  to_string = core.to_string,
}

