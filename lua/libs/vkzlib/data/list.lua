local MODULE = "list"

local list = require("vkzlib.internal").list

local pack = list.pack
local unpack = list.unpack

-- Merge multiple lists
---@param ... table
---@return table
local function concat(...)
  local res = {}
  local args = list.pack(...)
  for _, arg in ipairs(args) do
    for _, v in ipairs(arg) do
      table.insert(res, v)
    end
  end
  return res
end

return {
  pack = pack,
  unpack = unpack,
  concat = concat,
}
