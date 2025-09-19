local MODULE = "Data.list"

local internal = require("vkzlib.internal")
local list = internal.Data.list
local to_string = internal.core.to_string
local errmsg = internal.errmsg(MODULE)
local vassert = internal.assert

local pack = list.pack
local unpack = list.unpack

-- Merge multiple lists
---@param ... table
---@return table
local function concat(...)
	local deferred_errmsg = errmsg("concat")

	local res = {}
	for i = 1, select("#", ...) do
		---@type table
		local arg = select(i, ...)
		vassert(type(arg) == "table", deferred_errmsg(string.format("%dth argument is invalid: %s", i, to_string(arg))))
		for _, v in ipairs(arg) do
			table.insert(res, v)
		end
	end
	return res
end

---Find the first element that satisfy predicate
---@generic T
---@param pred fun(x: T): boolean
---@param xs T[]
---@return T?
local function find(pred, xs)
	for _, x in ipairs(xs) do
		if pred(x) == true then
			return x
		end
	end
end

---Find index of the first element that satisfy predicate
---@generic T
---@param pred fun(x: T): boolean
---@param xs T[]
---@return integer?
local function findIndex(pred, xs)
	for index, x in ipairs(xs) do
		if pred(x) == true then
			return index
		end
	end
end

---Find indices of every element that satisfy predicate
---@generic T
---@param pred fun(x: T): boolean
---@param xs T[]
---@return integer[]
local function findIndices(pred, xs)
	---@type integer[]
	local indices = {}
	for index, x in ipairs(xs) do
		if pred(x) == true then
			table.insert(indices, index)
		end
	end
	return indices
end

---Check if element `e` is in list `xs`
---@param e any
---@param xs any[]
---@return boolean
local function elem(e, xs)
	return find(function(x)
		return x == e
	end, xs) ~= nil
end

---Return index of the first element that equals `e` in `xs`
---@param e any
---@param xs any[]
---@return integer?
local function elemIndex(e, xs)
	return findIndex(function(x)
		return x == e
	end, xs)
end

---Return indices of every element that equals `e` in `xs`
---@param e any
---@param xs any[]
---@return integer[]
local function elemIndices(e, xs)
	return findIndices(function(x)
		return x == e
	end, xs)
end

---Left fold `xs` with `f`, with `initial` accumulator value
---@generic T, R
---@param f fun(acc: R, x: T): R
---@param initial R
---@param xs T[]
---@return R
local function foldl(f, initial, xs)
	local acc = initial
	for _, x in ipairs(xs) do
		acc = f(acc, x)
	end
	return acc
end

---Filter out elements of `xs` that doesn't satisfy `pred`
---@generic T
---@param pred fun(x: T): boolean
---@param xs T[]
---@return T[]
local function filter(pred, xs)
	return foldl(function(acc, x)
		if pred(x) == true then
			table.insert(acc, x)
		end
		return acc
	end, {}, xs)
end

local map = list.map

return {
	pack = pack,
	unpack = unpack,
	concat = concat,
	elem = elem,
	elemIndex = elemIndex,
	elemIndices = elemIndices,
	find = find,
	findIndex = findIndex,
	findIndices = findIndices,
	foldl = foldl,
	filter = filter,
	map = map,
}
