local internal = require("vkzlib.internal")
local core = internal.core
local list = internal.Data.list
local deep_copy = core.deep_copy
local to_string = core.to_string

local errmsg = internal.errmsg("Data.list")
local vassert = internal.assert

local all = core.all
local any = core.any
local foldl = core.foldl
local pack = list.pack
local unpack = list.unpack

---Reverse the list
---@generic T
---@param XS T[]
---@return T[]
local function reverse(XS)
  local res = {}
  for i = #XS, 1, -1 do
    table.insert(res, deep_copy(XS[i], true))
  end
  return res
end

---Merge multiple lists
---@generic T : table
---@param ... T
---@return T
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
---@param pred fun(X: T): boolean
---@param XS T[]
---@return T?
local function find(pred, XS)
	for _, X in ipairs(XS) do
		if pred(X) == true then
			return X
		end
	end
end

---Find index of the first element that satisfy predicate
---@generic T
---@param pred fun(X: T): boolean
---@param XS T[]
---@return integer?
local function findIndex(pred, XS)
	for index, X in ipairs(XS) do
		if pred(X) == true then
			return index
		end
	end
end

---Find indices of every element that satisfy predicate
---@generic T
---@param pred fun(X: T): boolean
---@param XS T[]
---@return integer[]
local function findIndices(pred, XS)
	---@type integer[]
	local indices = {}
	for index, X in ipairs(XS) do
		if pred(X) == true then
			table.insert(indices, index)
		end
	end
	return indices
end

---Check if element `e` is in list `xs`
---@param E any
---@param XS any[]
---@return boolean
local function elem(E, XS)
	return find(function(X)
		return X == E
	end, XS) ~= nil
end

---Return index of the first element that equals `e` in `xs`
---@param E any
---@param XS any[]
---@return integer?
local function elemIndex(E, XS)
	return findIndex(function(X)
		return X == E
	end, XS)
end

---Return indices of every element that equals `e` in `xs`
---@param E any
---@param XS any[]
---@return integer[]
local function elemIndices(E, XS)
	return findIndices(function(X)
		return X == E
	end, XS)
end

---Filter out elements of `xs` that doesn't satisfy `pred`
---@generic T
---@param pred fun(X: T): boolean
---@param XS T[]
---@return T[]
local function filter(pred, XS)
	return foldl(function(acc, X)
		if pred(X) == true then
			table.insert(acc, X)
		end
		return acc
	end, {}, XS)
end

local map = list.map

---Remove duplicates with equality predicate
---@generic T
---@param eq fun(A: T, B: T): boolean Equality predicate
---@param XS T[]
---@return T[]
local function nubBy(eq,  XS)
	return foldl(function(acc, X)
		if all(function(Y)
			return not eq(X, Y)
		end, acc) then
			table.insert(acc, X)
		end
		return acc
	end, {}, XS)
end

---Remove duplicates (Check equality using `==`)
---@generic T
---@param XS T[]
---@return T[]
local function nub(XS)
  return nubBy(function (A, B)
    return A == B
  end, XS)
end

return {
	all = all,
	any = any,
	foldl = foldl,
	pack = pack,
	unpack = unpack,
  reverse = reverse,
	concat = concat,
	elem = elem,
	elemIndex = elemIndex,
	elemIndices = elemIndices,
	find = find,
	findIndex = findIndex,
	findIndices = findIndices,
	filter = filter,
	map = map,
	nubBy = nubBy,
  nub = nub,
}
