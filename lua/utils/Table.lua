return {
  ---comment
  ---@param t table
  ---@return table
  keys = function (t)
    local res = {}
    for k, _ in pairs(t) do
      table.insert(res, k)
    end
    return res
  end,

  values = function (t)
    local res = {}
    for _, v in pairs(t) do
      table.insert(res, v)
    end
    return res
  end,

  ---comment
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
  end
}
