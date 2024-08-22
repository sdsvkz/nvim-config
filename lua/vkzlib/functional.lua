local _mod_name = "functional"

local internal = require("vkzlib.internal")
local core = internal.core
local list = internal.list
local typing = internal.typing

local get_qualified_name = internal.get_qualified_name(_mod_name)
local errmsg = internal.errmsg(_mod_name)

local log = {
  d = internal.logger(_mod_name, "debug"),
  t = internal.logger(_mod_name, "trace"),
}

---@class Function
---@field private raw function
---@field private value function
---@field private argc integer
---@field private isvararg boolean
---@operator call: Function
Function = {}

-- If `x` is an valid `Function` object
---@param x any
---@return boolean
Function.is_function_object = function (x)
  return
    typing.is_callable_object(x) and
    typing.is_type(x.raw, "function") and
    typing.is_type(x.value, "function") and
    typing.is_type(x.argc, "number") and
    typing.is_type(x.isvararg, "boolean")
end

---@class Function.new.Opts
---@field argc? integer
---@field isvararg? boolean
---@field raw? function

-- Create `Function` object from `f`
---@param f function
---@param opts? Function.new.Opts
---@return Function
Function.new = function (f, opts)
  assert(typing.is_type(f, "function"), errmsg("Function.new", "not a function"))
  opts = core.from_maybe({}, opts)
  ---@type integer?
  local argc = opts.argc
  ---@type boolean?
  local isvararg = opts.isvararg
  ---@type function?
  local raw = opts.raw
  assert(isvararg == nil or type(isvararg) == "boolean")
  assert(raw == nil or type(raw) == "function",
    errmsg("Function.new", "invalid raw")
  )
  local info = debug.getinfo(f, "u")
  assert(
    argc == nil or (
      type(argc) == "number" and argc >= info.nparams
    ),
    errmsg("Function.new", "invalid argc")
  )
  if isvararg == nil then
    isvararg = info.isvararg
  end
  ---@type Function
  local res = {
    raw = raw or f,
    value = f,
    argc = argc or info.nparams,
    isvararg = isvararg,
  }
  setmetatable(res, {
    __call = function (_, ...)
      return f(...)
    end
  })
  log.t("Function.new", "Object created", res)
  return res
end

-- Copy function object
---@param noref? boolean
function Function:copy(noref)
  assert(Function.is_function_object(self), errmsg("Function.copy", "not a function object"))
  return core.copy(self, noref)
end

setmetatable(Function, {
  __call = function (_, f, ...)
    if typing.is_type(f, "function") then
      return Function.new(f, ...)
    else
      return Function.copy(f, ...)
    end
  end
})

function Function:get()
  assert(type(self.value) == "function")
  return self.value
end

function Function:get_raw()
  return self.raw
end

function Function:get_argc()
  return self.argc
end

function Function:is_vararg()
  return self.isvararg
end

function Function:apply(...)
  assert(select("#", ...) >= self.argc, errmsg("Function:apply", "require more arguments"))
  return self(...)
end

-- Identity function that simply return argument itself
---@param x any
---@return any
local function id(x)
  return x
end

-- Add an argument in front and discard it
---@param f function | Function
---@return Function
local function to_const(f)
  local function _to_const(_f)
    return function (_, ...)
      return _f(...)
    end
  end
  if type(f) == "function" then
    local info = debug.getinfo(f)
    return Function.new(_to_const(f) , {
      argc = info.nparams + 1,
    })
  end
  assert(Function.is_function_object(f), errmsg("to_const", "not a valid function object"))
  return Function.new(_to_const(Function.get(f)), {
    argc = Function.get_argc(f) + 1,
    isvararg = Function.is_vararg(f),
    raw = Function.get_raw(f)
  })
end

-- Currying `f` with `argc`
---@param f Function
---@return Function
local function _curry(f)
  assert(Function.is_function_object(f))

  local function curried(...)
    local argv = list.pack(...)
    log.t("_curry.curried", "All args", argv)
    if argv.n >= Function.get_argc(f) then
      return Function.new(function ()
        return f(list.unpack(argv))
      end)
    end

    return Function.new(function (...)
      local storedArgs = { list.unpack(argv) }
      local newArgs = list.pack(...)
      log.t("_curry.curried.return", "New args", newArgs)
      for i = 1, newArgs.n do
        table.insert(storedArgs, newArgs[i])
      end
      return curried(list.unpack(storedArgs))
    end, {
      argc = Function.get_argc(f) - argv.n
    })
  end

  return curried()
end

-- Currying function `f` with optional argument count
-- By default, `maxArgc` is the number of arguments `f` expect
-- Vararg function must provide argc
---@param f function | Function
---@param argc? integer
---@return Function
local function curry(f, argc)
  -- TODO Refactor
  local nparams = nil
  ---@type Function.new.Opts
  local opts = {}
  if type(f) == "function" then
    local info = debug.getinfo(f)
    opts.isvararg = info.isvararg
    if not opts.isvararg then
      -- Not vararg, retrieve anything
      argc = core.from_maybe(info.nparams, argc)
      assert(argc >= 0, argc <= info.nparams, errmsg("curry", "argc out of range"))
    else
      -- If isvararg, leave argc untouched
      -- Let caller decide how many arguments it takes
      -- But argc must greater or equal than minimal requirement
      assert(type(argc) == "number", errmsg("curry", "argc is required for vararg function"))
      assert(argc >= info.nparams, errmsg("curry", "argc less than minimal requirement"))
    end
  else
    assert(Function.is_function_object(f), errmsg("curry", "Not a callable"))
    -- Almost the same
    opts.isvararg = Function.is_vararg(f)
    if not opts.isvararg then
      argc = core.from_maybe(Function.get_argc(f), argc)
      assert(argc >= 0, argc <= Function.get_argc(f), errmsg("curry", "argc out of range"))
    else
      assert(type(argc) == "number", errmsg("curry", "argc is required for vararg function"))
      assert(argc >= Function.get_argc(f), errmsg("curry", "argc less than minimal requirement"))
    end
  end

  f = Function(f, opts)

  log.t("curry", "Object passed to _curry", f)

  return _curry(f)
end

-- TODO `Function` compatibility
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
        log.t("memorize", "skipped")
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

-- TODO `Function` compatibility
-- Apply arguments to function `f`
---@param f function
---@vararg any
---@return any
local function apply(f, ...)
  assert(type(f) == "function", errmsg("apply", "not a function"))
  return f(...)
end

-- TODO `Function` compatibility
-- Compose two functions
---@param f function
---@param g function
---@return function
local function compose(f, g)
  return function (x, ...)
    return f(g(x), ...)
  end
end

-- TODO `Function` compatibility
-- Swap position of first and second argument
---@param f function
---@return function
local function flip(f)
  return function (y, x, ...)
    return f(x, y, ...)
  end
end

return {
  Function = Function,

  id = id,
  to_const = to_const,
  curry = curry,
  apply = apply,
  compose = compose,
  flip = flip,
  memorize = memorize,
}

