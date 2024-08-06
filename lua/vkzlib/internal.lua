local function pack(...)
  ---@type List
  local res = {...}
  res.n = #res
  return res
end

return {
  list = {
    pack = pack,
    unpack = unpack,
  },

  str = {
    join = table.concat
  }
}
