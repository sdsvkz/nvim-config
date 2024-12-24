local MODULE = "test"

-- TODO: This should be removed afterwards
local profile = require("profiles")

-- TODO: Get rid of profile. Use same strategy of log_level
if profile.debugging.enable_test == false then
  return
end

local internal = require "vkzlib.internal"
local functional = require("vkzlib.functional")

local log = {
  d = internal.logger(MODULE, "debug", 3)
}

-- Evaluate message doesn't matter until now
-- local assert = internal.assert

local Function = functional.Function

local id = functional.id
local to_const = functional.to_const
local curry = functional.curry
-- TODO: Rewrite test once memorize is reimplemented
-- local memorize = functional.memorize
local apply = functional.apply
local compose = functional.compose
local flip = functional.flip

local utils = {
  throw_test = function ()
    assert(false, "Test passed")
  end,
  fail = function (module)
    return function (group)
      return function (name)
        return function ()
          return "Test failed: " .. module .. "." .. group .. "." .. name
        end
      end
    end
  end,
  calc = function (a, b, c)
    return a + b * c
  end
}

local assert = internal.assert

-- functional

-- functional.Function begin
local fail = utils.fail("functional.Function")

-- functional.Function.new
local func_new_test = {
  test = function ()
    local f = Function:new { utils.calc }
    local info = debug.getinfo(utils.calc, "u")
    assert(
      f(2, 3, 1) == utils.calc(2, 3, 1) and
      f:get_argc() == info.nparams and
      f:is_vararg() == info.isvararg,

      fail("new")("basic")
    )
  end
}
-- functional.Function end

fail = utils.fail("functional")

-- functional.id
local id_test = {
  test = function ()
    assert(id(false) == false, fail("id")("basic"))
  end
}

-- functional.to_const
local to_const_test = {
  f = function (a, b)
    return a + b
  end
}

to_const_test.test = function ()
  local f = to_const_test.f
  assert(to_const(f) (1, 2, 3) == 2 + 3, fail("to_const")("basic"))
  assert((to_const(Function { f }) (1, 2, 3)) == 2 + 3, fail("to_const")("basic (Function)"))
end

-- functional.curry
local curry_test = {
  expect = utils.calc(2, 3, 1),
  one_by_one = function ()
    local _log = function (desc, ...)
      log.d("curry_test.one_by_one", desc, ...)
    end
    local _f = curry(utils.calc)
    _log("f = curry(function (a,b,c) return a + b * c end)", _f)
    local _f_2 = _f(2)
    _log("f(2)", _f_2)
    local _f_2_3 = _f_2(3)
    _log("f(2) (3)", _f_2_3)
    local _f_2_3_1 = _f_2_3(1)
    _log("f(2) (3) (1)", _f_2_3_1)
    return _f_2_3_1()
  end,
  pass_by_pack = function () return curry(utils.calc) (2, 3) (1) () end,
  with_argc_1 = function () return curry(utils.calc, 3) (2, 3, 1) () end,
  with_argc_2 = function () return curry(utils.calc, 3) (2) (3) (1) () end,
}

curry_test.test = function ()
  assert(curry_test.one_by_one() == curry_test.expect, fail("curry")("one_by_one"))
  assert(curry_test.one_by_one() == curry_test.pass_by_pack(), fail("curry")("pass_by_pack"))
  assert(curry_test.with_argc_1() == curry_test.with_argc_2(), fail("curry")("with_argc"))
end

-- TODO: Rewrite test once memorize is reimplemented
-- functional.memorize
-- local memorize_test = {
--   expect = "memorize",
--   fail = fail("memorize"),
-- }
--
-- memorize_test.f = function ()
--   return memorize_test.expect
-- end
--
-- memorize_test.test = function ()
--   local f = memorize(memorize_test.f)
--   local res, memorized = f()
--   assert(
--     (res == memorize_test.expect) and (memorized == false),
--     memorize_test.fail("basic")
--   )
--   res, memorized = f()
--   assert(
--     (res == memorize_test.expect) and (memorized == true),
--     memorize_test.fail("basic")
--   )
-- end

-- functional.apply
local apply_test = {
  expect = utils.calc(2, 3, 1),
  fail = fail("apply"),
}

apply_test.test = function ()
  assert(apply(utils.calc, 2, 3, 1) == apply_test.expect, apply_test.fail("basic"))
end

-- functional.compose
local compose_test = {
  add1 = function (x)
    return x + 1
  end,
  times3 = function (x)
    return x * 3
  end,
  fail = fail("compose"),
}

compose_test.expect = compose_test.add1(compose_test.times3(2))

compose_test.test = function ()
  assert(
    compose(compose_test.add1, compose_test.times3) (2) == compose_test.expect,
    compose_test.fail("basic")
  )
end

-- functional.flip
local flip_test = {
  fail = fail("flip"),
  expect = utils.calc(3, 2, 2),
  basic = function () return flip(utils.calc)(2, 3, 2) end,
}

flip_test.test = function ()
  assert(flip_test.basic() == flip_test.expect, flip_test.fail("basic"))
end

local M = {
  utils = utils,
  functional = {
    func_new_test = func_new_test,

    id_test = id_test,
    to_const_test = to_const_test,
    curry_test = curry_test,
    -- TODO: Rewrite test once memorize is reimplemented
    -- memorize_test = memorize_test,
    apply_test = apply_test,
    compose_test = compose_test,
    flip_test = flip_test,
  },
}

for _, m in ipairs({ M.functional }) do
  for _, comp in pairs(m) do
    if comp.test and type(comp.test) == "function" and debug.getinfo(comp.test).nparams == 0 then
      comp.test()
    end
  end
end

return M
