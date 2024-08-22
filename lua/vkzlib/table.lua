local _mod_name = "table"

local internal = require("vkzlib.internal")
local vkz_table = internal.table
local list = internal.list

local errmsg = internal.errmsg(_mod_name)

local map = vkz_table.map

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

-- Merge multiple tables
---@param behavior 'error'|'keep'|'force'
---@vararg table
---@return table
local function merge(behavior, ...)
  local args = list.pack(...)
  local res = {}
  for i = 1, args.n do
    for k, v in pairs(args[i]) do
      if behavior == 'force' or res[k] == nil then
        res[k] = v
      elseif behavior == 'error' then
        error(errmsg("merge", "key duplicated"))
      else
        assert(behavior == 'keep', errmsg("merge", "invalid argument: behavior"))
      end
    end
  end
  return res
end

merge = vim.tbl_extend or merge

return {
  keys = keys,
  values = values,
  merge = merge,
  map = map,
}
