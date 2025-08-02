local MODULE = "typing"

local internal = require("vkzlib.internal")

local is_type = internal.typing.is_type
local ensure_type = internal.typing.ensure_type
local is_callable = internal.typing.is_callable
local is_callable_object = internal.typing.is_callable_object

--[[
---@generic T
---@return vkzlib.Wrapper<T>
local function newtype()

  ---@class vkzlib.Wrapper<T>: { val: T }
  local Wrapper = { val = nil }

  ---@generic T
  ---@param val T
  ---@return vkzlib.Wrapper<T>
  function Wrapper:new(val)
    local instance = { val = val }
    setmetatable(instance, self)
    self.__index = self
    return instance
  end

  ---@generic T
  ---@return T
  function Wrapper:get()
    return self.val
  end

  return Wrapper

end

---@class Just<T>: vkzlib.Wrapper<T>
local Just = newtype()
]]

return {
  is_callable = is_callable,
  is_callable_object = is_callable_object,
  is_type = is_type,
  ensure_type = ensure_type,
  newtype = newtype,
}
