local MODULE = "typing"

local internal = require("vkzlib.internal")

local is_type = internal.typing.is_type
local ensure_type = internal.typing.ensure_type
local is_callable = internal.typing.is_callable
local is_callable_object = internal.typing.is_callable_object

return {
  is_callable = is_callable,
  is_callable_object = is_callable_object,
  is_type = is_type,
  ensure_type = ensure_type,
}
