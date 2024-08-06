---@class Function
---@field f function
---@field argc? integer

local internal = require("vkzlib.internal")
local list = internal.list

local function errmsg(comp, msg)
  return "vkzlib.functional." .. comp .. ": " .. msg
end

-- Identity function that simply return argument itself
---@param x any
---@return any
local function id(x)
  return x
end

-- Currying `f` with `argc`
---@param f function
---@param argc integer
---@return function
local function curryN(f, argc)
  local function curried(...)
    local argv = list.pack(...)
    VLog(argv)
    if argv.n >= argc then
      return function ()
        return f(list.unpack(argv))
      end
    end

    return function (...)
      local storedArgs = { list.unpack(argv) }
      local newArgs = {...}
      VLog(newArgs)
      for _, arg in ipairs(newArgs) do
        table.insert(storedArgs, arg)
      end
      return curried(list.unpack(storedArgs))
    end
  end

  return curried()
end

-- Currying function `f` with optional argument count
-- By default, `argc` is the number of arguments `f` expect
-- Vararg function must provide argc
---@param f function | Function
---@param argc? integer
---@return function
local function curry(f, argc)
  local info = {}
  if type(f) == "table" and type(f.f) == "function" then
    info = debug.getinfo(f.f, "u")
    if info.isvararg and type(f.argc) == "number" then
      -- Retrieve argc from record
      argc = argc or f.argc
    end
    -- Unwrapping
    f = f.f
  elseif type(f) == "function" then
    info = debug.getinfo(f, "u")
  else
    error(errmsg("curry", "not a function"))
  end

  if info.isvararg then
    assert(argc and argc >= 0, errmsg("curry", "argc is required for vararg function"))
    curryN(f, argc)
  end

  if not argc then
    return curryN(f, info.nparams)
  end

  assert(argc >= 0 and argc <= info.nparams, errmsg("curry", "argc out of range"))
  return curryN(f, argc)
end

-- Make function `f` memorize its result
---@param f function
---@return function
local function memorize(f)
  assert(type(f) == "function" and debug.getinfo(f, "u").nparams == 0,
    errmsg("memorize", "only function with no argument can be memorized")
  )
  local function closure()
    local mem = nil
    return function ()
      if mem ~= nil then
        VLog("memorize: skipped")
        if _DEBUG then
          return mem, true
        end
        return mem
      end
      mem = f()
      if _DEBUG then
        return mem, false
      end
      return mem
    end

  end

  return closure()
end

-- Apply arguments to function `f`
---@param f function
---@vararg any
---@return any
local function apply(f, ...)
  assert(type(f) == "function", errmsg("apply", "not a function"))
  return f(...)
end

-- Compose two functions
---@param f function
---@param g function
---@return function
local function compose(f, g)
  return function (x, ...)
    return f(g(x), ...)
  end
end

-- Swap position of first and second argument
---@param f function
---@return function
local function flip(f)
  return function (y, x, ...)
    return f(x, y, ...)
  end
end

return {
  id = id,
  curry = curry,
  apply = apply,
  compose = compose,
  flip = flip,
  memorize = memorize,
}

