local MODULE = "table"

local internal = require("vkzlib.internal")
local tbl = internal.table
local list = internal.list

local errmsg = internal.errmsg(MODULE)

local map = tbl.map

-- Get keys of table
---@param t table
---@return any[]
local function keys(t)
  local res = {}
  for k, _ in pairs(t) do
    table.insert(res, k)
  end
  return res
end

-- Get values of table
---@param t table
---@return any[]
local function values(t)
  local res = {}
  for _, v in pairs(t) do
    table.insert(res, v)
  end
  return res
end

-- Merge two or more tables
---@param behavior 'error'|'keep'|'force' Decides what to do if a key is found in more than one map:
---      - "error": raise an error
---      - "keep":  use value from the leftmost map
---      - "force": use value from the rightmost map
---@param ... table Two or more tables
---@return table -- Merged table
local function merge(behavior, ...)
  local deferred_errmsg = errmsg("merge")
  local args = list.pack(...)
  local res = {}
  for i = 1, args.n do
    for k, v in pairs(args[i]) do
      if behavior == 'force' or res[k] == nil then
        res[k] = v
      elseif behavior == 'error' then
        error(deferred_errmsg("key duplicated") ())
      else
        assert(behavior == 'keep', deferred_errmsg("invalid argument: behavior"))
      end
    end
  end
  return res
end

merge = vim.tbl_extend or merge

-- Merge two or more tables recursively
---@param behavior 'error'|'keep'|'force' Decides what to do if a key is found in more than one map:
---      - "error": raise an error
---      - "keep":  use value from the leftmost map
---      - "force": use value from the rightmost map
---@param ... table Two or more tables
---@return table -- Merged table
local function deep_merge(behavior, ...)
  local deferred_errmsg = errmsg("deep_merge")
  -- TODO
  assert(false, deferred_errmsg('Not implemented yet'))
  return {}
end

deep_merge = vim.tbl_deep_extend or deep_merge

return {
  keys = keys,
  values = values,
  merge = merge,
  deep_merge = deep_merge,
  map = map,
}
