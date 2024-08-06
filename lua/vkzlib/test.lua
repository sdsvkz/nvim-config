if _DEBUG == "OFF" then
  return {}
end

local functional = require("vkzlib.functional")
local list = require("vkzlib.list")
local str = require("vkzlib.str")
local vkz_table = require("vkzlib.table")

local id = functional.id
local curry = functional.curry
local memorize = functional.memorize
local apply = functional.apply
local compose = functional.compose
local flip = functional.flip

local utils = {
  throw_test = function ()
    assert(false, "Test passed")
  end,
  fail = curry(function (module, group, name)
    return "Test failed: " .. module .. "." .. group .. "." .. name
  end),
  calc = function (a, b, c)
    return a + b * c
  end
}

-- functional
local fail = utils.fail("functional")

-- functional.id
local id_test = {
  test = function ()
    assert(id(false) == false, utils.fail("functional", "id", "basic"))
  end
}

-- functional.curry
local curry_test = {
  expect = utils.calc(2, 3, 1),
  one_by_one = function () return curry(utils.calc) (2) (3) (1) () end,
  pass_by_pack = function () return curry(utils.calc) (2, 3) (1) () end,
  with_argc_1 = function () return curry(utils.calc, 3) (2, 3, 1) () end,
  with_argc_2 = function () return curry(utils.calc, 3) (2) (3) (1) () end,
}

curry_test.test = function ()
  assert(curry_test.one_by_one() == curry_test.expect, utils.fail("functional", "curry", "one_by_one"))
  assert(curry_test.one_by_one() == curry_test.pass_by_pack(), utils.fail("functional", "curry", "pass_by_pack"))
  assert(curry_test.with_argc_1() == curry_test.with_argc_2(), utils.fail("functional", "curry", "with_argc"))
end

-- functional.memorize
local memorize_test = {
  expect = "memorize",
  fail = fail("memorize"),
}

memorize_test.f = function ()
  return memorize_test.expect
end

memorize_test.test = function ()
  local f = memorize(memorize_test.f)
  local res, memorized = f()
  assert(
    (res == memorize_test.expect) and (memorized == false),
    memorize_test.fail("basic") ()
  )
  res, memorized = f()
  assert(
    (res == memorize_test.expect) and (memorized == true),
    memorize_test.fail("basic") ()
  )
end

-- functional.apply
local apply_test = {
  expect = utils.calc(2, 3, 1),
  fail = fail("apply"),
}

apply_test.test = function ()
  assert(apply(utils.calc, 2, 3, 1) == apply_test.expect, apply_test.fail("basic") ())
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
    compose_test.fail("basic") ()
  )
end

-- functional.flip
local flip_test = {
  fail = fail("flip"),
  expect = utils.calc(3, 2, 2),
  basic = function () return flip(utils.calc)(2, 3, 2) end,
}

flip_test.test = function ()
  assert(flip_test.basic() == flip_test.expect, flip_test.fail ("basic") ())
end

local M = {
  utils = utils,
  functional = {
    id_test = id_test,
    curry_test = curry_test,
    memorize_test = memorize_test,
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

