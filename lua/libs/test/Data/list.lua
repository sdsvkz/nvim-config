local MODULE = "vkzlib.Data.list.test"

local internal = require("vkzlib.internal")
local LazyValue = require("vkzlib.Data.LazyValue")
local core = require("vkzlib.core")
local equals = core.equals

local log = {
	d = internal.logger(MODULE, "debug", 3),
}

local vassert = core.assert

local function fail(group)
	return function(name)
		return LazyValue:new(function()
			return string.format("Test failed: %s.%s.%s", MODULE, group, name)
		end)
	end
end

local list = require("vkzlib.Data.list")
local nubBy = list.nubBy

---@type Test.vkzlib.Module
local M = {
  tests = {},
}

local test_nubBy = {
  fail = fail("nubBy"),
  T = {
    { "1", v = 1 },
    { "1", v = 2 },
    { "2", v = 3 },
    { "1", v = 4 },
    { "2", v = 5 },
    { "3", v = 6 },
    { "1", v = 7 },
    { "2", v = 8 },
    { "4", v = 9 },
    { "3", v = 10 },
  },
  eq = function (A, B)
    return A[1] == B[1]
  end,
  expect = {
    { "1", v = 1 },
    { "2", v = 3 },
    { "3", v = 6 },
    { "4", v = 9 },
  },
}

function test_nubBy.actual()
  return nubBy(test_nubBy.eq, test_nubBy.T)
end

function test_nubBy.test()
  vassert(equals(test_nubBy.expect, test_nubBy.actual()), test_nubBy.fail("basic"))
  return true
end

M.tests = {
  test_nubBy = test_nubBy,
}

return M

