local core = require("vkzlib.internal").core

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

---Return the same block but will only be executed once
---@generic T : function
---@param block T
---@return T
local function once(block)
  ---@type boolean
  local done = false
  local res = nil
  return function(...)
    if done then
      return res
    end
    return block(...)
  end
end

return {
	also = core.also,
	all = core.all,
	assert = core.assert,
	any = core.any,
	conditional = core.conditional,
	deep_copy = core.deep_copy,
	enable_if = core.enable_if,
	equals = core.equals,
	first_not_nil = first_not_nil,
	foldl = core.foldl,
	from_maybe = core.from_maybe,
	from_type = core.from_type,
	let = core.let,
  once = once,
	to_string = core.to_string,
}
