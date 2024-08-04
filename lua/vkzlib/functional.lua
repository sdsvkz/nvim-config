local function curry1(f)
  return function (x)
    return function ()
      f(x)
    end
  end
end

local function curryN(f, argc)
  if argc == 0 then
    return f
  else
    curryN(function (...)
      f(...)

    end, argc - 1)
  end
end

return {
  curryN = curryN
}
