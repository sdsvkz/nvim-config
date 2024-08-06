-- Get keys of table
---@param t table
---@return table
local function keys(t)
  local res = {}
  for k, _ in pairs(t) do
    table.insert(res, k)
  end
  return res
end

-- Get values of table
---@param t table
---@return table
local function values(t)
  local res = {}
  for _, v in pairs(t) do
    table.insert(res, v)
  end
  return res
end

-- Merge multiple tables
---@vararg table
---@return table
local function concat(...)
  local res = {}
  for _, t in ipairs({...}) do
    for k, v in pairs(t) do
      res[k] = v
    end
  end
  return res
end

-- Append elements of array to table
---@param t table
---@param l List
local function append(t, l)
  for _, v in ipairs(l) do
    table.insert(t, v)
  end
end

return {
  keys = keys,
  values = values,
  concat = concat,
  append = append,
}
