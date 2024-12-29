local MODULE = "core"

local core = require('vkzlib.internal').core

return {
  all = core.all,
  also = core.also,
  any = core.any,
  conditional = core.conditional,
  deep_copy = core.deep_copy,
  enable_if = core.enable_if,
  equals = core.equals,
  from_maybe = core.from_maybe,
  from_type  = core.from_type,
  let = core.let,
  to_string = core.to_string,
}

