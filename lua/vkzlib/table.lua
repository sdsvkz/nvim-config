return {
  -- Get keys of table
  ---@param t table
  ---@return table
  keys = function (t)
    local res = {}
    for k, _ in pairs(t) do
      table.insert(res, k)
    end
    return res
  end,

  -- Get values of table
  ---@param t table
  ---@return table
  values = function (t)
    local res = {}
    for _, v in pairs(t) do
      table.insert(res, v)
    end
    return res
  end,

  ---Merge multiple tables
  ---@vararg table
  ---@return table
  concat = function (...)
    local res = {}
    for _, t in ipairs({...}) do
      for k, v in pairs(t) do
        res[k] = v
      end
    end
    return res
  end,

  ---Append element of list to table
  ---@param t table
  ---@param list table
  append = function (t, list)
    for _, v in ipairs(list) do
      table.insert(t, v)
    end
  end
}
