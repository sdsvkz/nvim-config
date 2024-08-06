---@class List
---@field n? integer

local list = require("vkzlib.internal").list

-- Merge multiple lists
---@vararg List
---@return List
local function concat(...)
  local res = {}
  for _, l in ipairs({...}) do
    for i, v in ipairs(l) do
      res[i] = v
    end
  end
  return res
end

return {
  pack = table.pack or list.pack,
  unpack = list.unpack,
  concat = concat,
}
