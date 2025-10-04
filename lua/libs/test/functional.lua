local MODULE = "vkzlib.functional.test"

local internal = require("vkzlib.internal")
local LazyValue = require("vkzlib.Data.LazyValue")

local log = {
	t = internal.logger(MODULE, "trace", 3),
}

local vassert = internal.assert

local functional = require("vkzlib.functional")
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
	calc = function(a, b, c)
		return a + b * c
	end,
}

local function fail(group)
	return function(name)
		return LazyValue:new(function()
			return string.format("Test failed: %s.%s.%s", MODULE, group, name)
		end)
	end
end

-- functional.Function begin

-- functional.Function.new
local test_func_new = {
	test = function()
		local f = Function:new({ utils.calc })
		local info = debug.getinfo(utils.calc, "u")
		vassert(
			f(2, 3, 1) == utils.calc(2, 3, 1) and f:get_nparams() == info.nparams and f:is_vararg() == info.isvararg,
			fail("new")("basic")
		)
    return true
	end,
}

-- functional.Function end

-- functional.id
local test_id = {
	test = function()
		vassert(id(false) == false, fail("id")("basic"))
    return true
	end,
}

-- functional.to_const
local test_to_const = {
	f = function(a, b)
		return a + b
	end,
}

function test_to_const.test()
	local f = test_to_const.f
	vassert(to_const(f)(1, 2, 3) == 2 + 3, fail("to_const")("basic"))
	vassert((to_const(Function:new({ f }))(1, 2, 3)) == 2 + 3, fail("to_const")("basic (Function)"))
  return true
end

-- functional.curry
local test_curry = {
	expect = utils.calc(2, 3, 1),
	one_by_one = function()
		local _log = function(desc, ...)
			log.t("test_curry.one_by_one", desc, ...)
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
	pass_by_pack = function()
		return curry(utils.calc)(2, 3)(1)()
	end,
	with_nparams_1 = function()
		return curry(utils.calc, 3)(2, 3, 1)()
	end,
	with_nparams_2 = function()
		return curry(utils.calc, 3)(2)(3)(1)()
	end,
}

function test_curry.test()
	vassert(test_curry.one_by_one() == test_curry.expect, fail("curry")("one_by_one"))
	vassert(test_curry.one_by_one() == test_curry.pass_by_pack(), fail("curry")("pass_by_pack"))
	vassert(test_curry.with_nparams_1() == test_curry.with_nparams_2(), fail("curry")("with_nparams"))
  return true
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
--   vassert(
--     (res == memorize_test.expect) and (memorized == false),
--     memorize_test.fail("basic")
--   )
--   res, memorized = f()
--   vassert(
--     (res == memorize_test.expect) and (memorized == true),
--     memorize_test.fail("basic")
--   )
--   return true
-- end

-- functional.apply
local test_apply = {
	expect = utils.calc(2, 3, 1),
	fail = fail("apply"),
}

function test_apply.test()
	vassert(apply(utils.calc, 2, 3, 1) == test_apply.expect, test_apply.fail("basic"))
  return true
end

-- functional.compose
local test_compose = {
	add1 = function(x)
		return x + 1
	end,
	times3 = function(x)
		return x * 3
	end,
	fail = fail("compose"),
}

test_compose.expect = test_compose.add1(test_compose.times3(2))

function test_compose.test()
	vassert(compose(test_compose.add1, test_compose.times3)(2) == test_compose.expect, test_compose.fail("basic"))
  return true
end

---functional.flip
local test_flip = {
	fail = fail("flip"),
	expect = utils.calc(3, 2, 2),
	basic = function()
		return flip(utils.calc)(2, 3, 2)
	end,
}

function test_flip.test()
	vassert(test_flip.basic() == test_flip.expect, test_flip.fail("basic"))
  return true
end

---@type Test.vkzlib.Module
local M = {
	utils = utils,
	tests = {
		test_func_new = test_func_new,

		test_id = test_id,
		test_to_const = test_to_const,
		test_curry = test_curry,
		-- TODO: Rewrite test once memorize is reimplemented
		-- memorize_test = memorize_test,
		test_apply = test_apply,
		test_compose = test_compose,
		test_flip = test_flip,
	},
}

return M
