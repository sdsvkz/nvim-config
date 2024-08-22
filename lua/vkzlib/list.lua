local _mod_name = "list"

---@class Array<T>: { [integer]: T }
---@field n integer?

---@class List: { [integer]: any }
---@field n integer?

local list = require("vkzlib.internal").list

local pack = list.pack
local unpack = list.unpack

-- Merge multiple lists
---@vararg List
---@return List
local function concat(...)
  local res = {}
  local args = list.pack(...)
  for i = 1, args.n do
    if args[i].n then
      for j = 1, args[i].n do
        res[j] = args[i][j]
      end
    else
      for j, v in ipairs(args[i]) do
        res[j] = v
      end
    end
  end
  return res
end

return {
  pack = pack,
  unpack = unpack,
  concat = concat,
}
