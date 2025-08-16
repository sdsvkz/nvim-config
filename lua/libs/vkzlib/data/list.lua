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

---Check if element `e` is in list `xs`
---@param xs any[]
---@param e any
---@return boolean
local function elem(xs, e)
  for _, x in ipairs(xs) do
    if x == e then
      return true
    end
  end
  return false
end

return {
  pack = pack,
  unpack = unpack,
  concat = concat,
  elem = elem,
}
