local MODULE = "vkzlib.Data.table.test"

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

local tbl = require("vkzlib.Data.table")
local deep_merge = tbl._backup.backup_deep_merge

---@type Test.vkzlib.Module
local M = {
	tests = {},
}

local test_deep_merge = {
	fail = fail("deep_merge"),
	T1 = {
		VALUE_OVERRIDE_TEST = 1,
		NESTED_TABLE = {
			NESTED_TABLE_VALUE_OVERRIDE_TEST = 2,
			TABLE_OVERRIDE_TEST = {
				TABLE_OVERRIDE_TEST_VALUE = 3,
			},
			TABLE_MERGE_TEST = {
				a = 4,
				b = 5,
				c = 6,
			},
		},
	},
	T2 = {
		VALUE_OVERRIDE_TEST = 101,
		NESTED_TABLE = {
			NESTED_TABLE_VALUE_OVERRIDE_TEST = 102,
			TABLE_OVERRIDE_TEST = 103,
			TABLE_MERGE_TEST = {
				c = 104,
				d = 105,
				b = 106,
				e = 107,
			},
		},
	},
	keep = {},
	force = {},
	error = {},
}

test_deep_merge.keep = {
	expect = function()
		local T1 = test_deep_merge.T1
		local T2 = test_deep_merge.T2
		return type(vim) == "table" and type(vim.tbl_deep_extend) == "function" and vim.tbl_deep_extend("keep", T1, T2)
			or {
				VALUE_OVERRIDE_TEST = T1.VALUE_OVERRIDE_TEST,
				NESTED_TABLE = {
					NESTED_TABLE_VALUE_OVERRIDE_TEST = T1.NESTED_TABLE.NESTED_TABLE_VALUE_OVERRIDE_TEST,
					TABLE_OVERRIDE_TEST = T1.NESTED_TABLE.TABLE_OVERRIDE_TEST,
					TABLE_MERGE_TEST = {
						a = T1.NESTED_TABLE.TABLE_MERGE_TEST.a,
						b = T1.NESTED_TABLE.TABLE_MERGE_TEST.b,
						c = T1.NESTED_TABLE.TABLE_MERGE_TEST.c,
						d = T2.NESTED_TABLE.TABLE_MERGE_TEST.d,
						e = T2.NESTED_TABLE.TABLE_MERGE_TEST.e,
					},
				},
			}
	end,
	actual = function()
		return deep_merge("keep", test_deep_merge.T1, test_deep_merge.T2)
	end,
}

test_deep_merge.force = {
	expect = function()
		local T1 = test_deep_merge.T1
		local T2 = test_deep_merge.T2
		return {
			VALUE_OVERRIDE_TEST = T2.VALUE_OVERRIDE_TEST,
			NESTED_TABLE = {
				NESTED_TABLE_VALUE_OVERRIDE_TEST = T2.NESTED_TABLE.NESTED_TABLE_VALUE_OVERRIDE_TEST,
				TABLE_OVERRIDE_TEST = T2.NESTED_TABLE.TABLE_OVERRIDE_TEST,
				TABLE_MERGE_TEST = {
					a = T1.NESTED_TABLE.TABLE_MERGE_TEST.a,
					b = T2.NESTED_TABLE.TABLE_MERGE_TEST.b,
					c = T2.NESTED_TABLE.TABLE_MERGE_TEST.c,
					d = T2.NESTED_TABLE.TABLE_MERGE_TEST.d,
					e = T2.NESTED_TABLE.TABLE_MERGE_TEST.e,
				},
			},
		}
	end,
	actual = function()
		return deep_merge("force", test_deep_merge.T1, test_deep_merge.T2)
	end,
}

test_deep_merge.error = {
	expect = function()
		if type(vim) == "table" and type(vim.tbl_deep_extend) == "function" then
      local ok = pcall(vim.tbl_deep_extend, "error", test_deep_merge.T1, test_deep_merge.T2)
			return ok
		else
			return false
		end
	end,
	actual = function()
		local ok = pcall(deep_merge, "error", test_deep_merge.T1, test_deep_merge.T2)
    return ok
	end,
}

function test_deep_merge.test()
	vassert(equals(test_deep_merge.keep.expect(), test_deep_merge.keep.actual()), test_deep_merge.fail("keep"))
	vassert(equals(test_deep_merge.force.expect(), test_deep_merge.force.actual()), test_deep_merge.fail("force"))
  vassert(equals(test_deep_merge.error.expect(), test_deep_merge.error.actual()), test_deep_merge.fail("error"))
	return true
end

M.tests = {
  test_deep_merge = test_deep_merge,
}

return M
