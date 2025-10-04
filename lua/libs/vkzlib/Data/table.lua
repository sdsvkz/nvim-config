local internal = require("vkzlib.internal")
local core = internal.core
local to_string = core.to_string
local ensure_type = internal.typing.ensure_type
local is_list = internal.typing.is_list
local tbl = internal.Data.table

local errmsg = internal.errmsg("Data.table")

local is_empty = tbl.is_empty
local map = tbl.map

---Get keys of table
---@param t table
---@return any[]
local function keys(t)
	local res = {}
	for k, _ in pairs(t) do
		table.insert(res, k)
	end
	return res
end

---Get values of table
---@param t table
---@return any[]
local function values(t)
	local res = {}
	for _, v in pairs(t) do
		table.insert(res, v)
	end
	return res
end

---@param deferred_errmsg fun(msg: string | LazyValue<string>): LazyValue<string>
---@param behavior any
---@param TABLES any
local function _check_merge_args(deferred_errmsg, behavior, TABLES)
  if behavior ~= 'error' and behavior ~= 'keep' and behavior ~= 'force' then
    error(deferred_errmsg("behavior: Expected one of 'error', 'keep', 'force', got " .. to_string(behavior)):toStrict())
  end
  if TABLES.n < 2 then
    error(deferred_errmsg("Need at least 2 tables to merge"):toStrict())
  end
  for i = 1, TABLES.n do
    ensure_type(TABLES[i], "table")
  end
end

---@param t any
---@return boolean
local function _can_merge(t)
  return type(t) == "table" and (is_empty(t) or not is_list(t))
end

---@param behavior 'error'|'keep'|'force'
---@param is_deep_merge boolean
---@param deferred_errmsg fun(msg: string | LazyValue<string>): LazyValue<string>
---@param TABLES { n: integer, [integer]: table }
---@return table
local function _backup_merge_recur(behavior, is_deep_merge, deferred_errmsg, TABLES)
  local res = {}
  for i = 1, TABLES.n do
    local TABLE = TABLES[i]
    for K, V in pairs(TABLE) do
      if is_deep_merge and _can_merge(V) and _can_merge(res[K]) then
        res[K] = _backup_merge_recur(behavior, true, deferred_errmsg, { n = 2, res[K], V })
      elseif behavior ~= "force" and res[K] ~= nil then
        if behavior == 'error' then
          error(deferred_errmsg("duplicate key found: " .. to_string(K)):toStrict())
        end
      else
        res[K] = V
      end
    end
  end
  return res
end

local function _backup_merge(component, behavior, is_deep_merge, ...)
  local deferred_errmsg = errmsg(component)
  ---@type integer
  local argc = select("#", ...)
  ---@type table[]
  local TABLES = { n = argc, ... }
  _check_merge_args(deferred_errmsg, behavior, TABLES)
  return _backup_merge_recur(behavior, is_deep_merge, deferred_errmsg, TABLES)
end

---Merge two or more tables
---@param behavior 'error'|'keep'|'force' Decides what to do if a key is found in more than one map:
---      - "error": raise an error
---      - "keep":  use value from the leftmost map
---      - "force": use value from the rightmost map
---@param ... table Two or more tables
---@return table -- Merged table
local function backup_merge(behavior, ...)
  return _backup_merge("merge", behavior, false, ...)
end

local merge = vim.tbl_extend or backup_merge

---Merge two or more tables recursively
---@param behavior 'error'|'keep'|'force' Decides what to do if a key is found in more than one map:
---      - "error": raise an error
---      - "keep":  use value from the leftmost map
---      - "force": use value from the rightmost map
---@param ... table Two or more tables
---@return table -- Merged table
local function backup_deep_merge(behavior, ...)
	return _backup_merge("deep_merge", behavior, true, ...)
end

local deep_merge = vim.tbl_deep_extend or backup_deep_merge

---Fold values in the table using the given left-associative binary operator
---@generic K, V, R
---@param f fun(acc: R, V: V): R
---@param INITIAL R Initial value of accumulator
---@param TABLE table<K, V> table to fold
---@return R
local function foldl(f, INITIAL, TABLE)
	local acc = core.deep_copy(INITIAL, true)
	for _, v in pairs(TABLE) do
		acc = f(acc, v)
	end
	return acc
end

---Fold the keys and values in the table using the given left-associative binary operator
---@generic K, V, R
---@param f fun(acc: R, K: K, V: V): R
---@param INITIAL R Initial value of accumulator
---@param TABLE table<K, V> table to fold
---@return R
local function foldlWithKey(f, INITIAL, TABLE)
	local acc = core.deep_copy(INITIAL, true)
	for k, v in pairs(TABLE) do
		acc = f(acc, k, v)
	end
	return acc
end

---If any of the values in the table satisfy `pred`
---@generic K, V
---@param pred fun(V: V): boolean
---@param TABLE table<K, V>
---@return boolean
local function any(pred, TABLE)
	return foldl(function(acc, V)
		return acc or pred(V)
	end, false, TABLE)
end

---@generic K, V
---@param pred fun(K: K, V: V): boolean
---@param TABLE table<K, V>
---@return boolean
local function anyWithKey(pred, TABLE)
	return foldlWithKey(function(acc, K, V)
		return acc or pred(K, V)
	end, false, TABLE)
end

return {
	keys = keys,
	values = values,
	merge = merge,
	deep_merge = deep_merge,
  is_empty = is_empty,
	map = map,
	foldl = foldl,
	foldl_with_key = foldlWithKey,
	any = any,
	any_with_key = anyWithKey,
  _backup = {
    backup_deep_merge = backup_deep_merge,
    backup_merge = backup_merge,
  },
}
