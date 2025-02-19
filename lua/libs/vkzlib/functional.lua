local MODULE = "functional"

local internal = require("vkzlib.internal")
local core = internal.core
local list = internal.list

local get_qualified_name = internal.get_qualified_name(MODULE)
local errmsg = internal.errmsg(MODULE)
local assert = internal.assert

local log = {
  d = internal.logger(MODULE, "debug"),
  t = internal.logger(MODULE, "trace"),
}

---@class vkzlib.data.Function
---@field protected _raw function Original `function`
---@field protected _value function Wrapped `function`
---@field protected _nparams integer Number of Parameter of wrapped `function`
---@field protected _isvararg boolean Whether wrapped `function` has variadic argument
---
---@operator call(...): ...
local Function = {}

---If `x` is an valid `Function` object
---@param x any
---@return boolean
Function.is_function_object = function (x)
  -- FIX: I think this wouldn't be true for subclasses (Inheritance implementation from PiL 16.2)
  return getmetatable(x).__index == Function
end

---@class vkzlib.data.Function.new.Params
---@field [1] function
---@field nparams integer?
---@field skip_nparams_check boolean? Disable check for `nparams >= debug.getinfo(f, "u").nparams`
---@field isvararg boolean?
---@field raw function?

---Create `Function` object from `f`
---@param params? vkzlib.data.Function.new.Params
---@return vkzlib.data.Function
---
---@see vkzlib.data.Function.new.Params
---@see vkzlib.data.Function
function Function:new(params)
  local deferred_errmsg = errmsg("Function:new")
  assert(type(params) == "table",
    deferred_errmsg("This function receive table as argument")
  )
  ---@type function
  local f = params[1]
  assert(type(f) == "function",
    deferred_errmsg("1st argument not a function")
  )
  ---@type integer?
  local nparams = params.nparams
  assert(nparams == nil or type(nparams) == "number",
    deferred_errmsg("Invalid opts.nparams")
  )
  ---@type boolean?
  local isvararg = params.isvararg
  assert(isvararg == nil or type(isvararg) == "boolean",
    deferred_errmsg("Invalid opts.isvararg")
  )
  ---@type function?
  local raw = params.raw
  assert(raw == nil or type(raw) == "function",
    deferred_errmsg("Invalid opts.raw")
  )
  local skip_nparams_check = type(params.skip_nparams_check) == "boolean" and params.skip_nparams_check or false
  local info = debug.getinfo(f, "u")
  assert(nparams == nil or skip_nparams_check or nparams >= info.nparams, function ()
    return deferred_errmsg(string.format(
      "Required `nparams` < Expected `debug.getinfo(f, 'u').nparams` (%i < %i)",
      nparams,
      info.nparams
    )) ()
  end)

  if isvararg == nil then
    isvararg = info.isvararg
  end
  ---@type vkzlib.data.Function
  ---@diagnostic disable-next-line: missing-fields
  local res = {
    _raw = raw or f,
    _value = f,
    _nparams = nparams or info.nparams,
    _isvararg = isvararg,
  }

  -- This method should easily implement inheritance
  -- Literally use self (class object) as meta table
  -- But seems complicated to implement operator overload

  -- Make callable
  -- !!! This fucked up because this will override call operator for all objects every time you instantiate an object
  -- self.__call = function (_, ...)
  --   return f(...)
  -- end

  -- Make colon call search method in class object
  -- self.__index = self

  -- setmetatable(res, self)


  setmetatable(res, {
    -- Overload call operator for instance
    __call = function (_, ...)
      return f(...)
    end,
    -- Make colon call search method in class object
    __index = self
  })

  log.t("Function:new", "Object created", res)
  return res
end

---Copy function object
---@param noref boolean?
function Function:copy(noref)
  local deferred_errmsg = errmsg("Function:copy")
  assert(Function.is_function_object(self),
    deferred_errmsg("not a `Function`")
  )
  return core.deep_copy(self, noref)
end

function Function:get()
  assert(type(self._value) == "function")
  return self._value
end

function Function:get_raw()
  assert(type(self._raw) == "function")
  return self._raw
end

function Function:get_nparams()
  assert(type(self._nparams) == 'number')
  return self._nparams
end

function Function:is_vararg()
  assert(type(self._isvararg) == "boolean")
  return self._isvararg
end

function Function:apply(...)
  local deferred_errmsg = errmsg("Function:apply")
  assert(select("#", ...) >= self._nparams,
    deferred_errmsg("require more arguments")
  )
  return self(...)
end

---Identity function that simply return argument itself
---@param x any
---@return any
local function id(x)
  return x
end

---Add an argument in front and discard it
---@param f function | vkzlib.data.Function
---@return vkzlib.data.Function
local function to_const(f)
  local deferred_errmsg = errmsg("to_const")
  local function _to_const(f_)
    return function (_, ...)
      return f_(...)
    end
  end
  if type(f) == "function" then
    local info = debug.getinfo(f)
    return Function:new { _to_const(f),
      nparams = info.nparams + 1,
    }
  end
  assert(Function.is_function_object(f),
    deferred_errmsg("not a valid function object")
  )
  return Function:new { _to_const(f:get()),
    nparams = f:get_nparams() + 1,
    isvararg = f:is_vararg(),
    raw = f:get_raw()
  }
end

---Currying `f` with `nparams`
---@param f vkzlib.data.Function
---@return vkzlib.data.Function
local function _curry(f)
  -- Don't write variables here to avoid side effect

  local deferred_errmsg = errmsg("_curry")
  assert(Function.is_function_object(f), deferred_errmsg("1st argument is not a function object"))

  ---A clousure to contained arguments
  ---@param ... any All previously passed arguments
  ---@return vkzlib.data.Function curried Handler for next call
  local function curried(...)
    -- Don't write variables here to avoid side effect

    -- Storage of arguments (Cannot upvalue `...`)
    local argv = list.pack(...)
    log.t("_curry.curried", "All args", argv)
    if argv.n >= f:get_nparams() then
      -- This means all parameters have been filled
      log.t("_curry.curried", "Finalized", string.format("%i = argv.n >= f:get_nparams() = %i", argv.n, f:get_nparams()))
      -- Apply arguments and return result in next call
      return Function:new {
        function ()
          return f(list.unpack(argv))
        end,
        nparams = 0,
        isvararg = f:is_vararg(),
        raw = f:get_raw()
      }
    end

    local function res(...)
      -- New arguments in this call
      local newArgs = list.pack(...)
      if newArgs.n == 0 then
        log.t("_curry.curried@return", "No arg, skipped")
        return Function:new { res, nparams = argv.n, isvararg = f:is_vararg(), raw = f:get_raw() }
      end

      -- Copy of `argv`, to perform side effect
      -- This will be the new `argv`
      local storedArgs = { list.unpack(argv) }
      log.t("_curry.curried@return", "New args", newArgs)
      for i = 1, newArgs.n do
        -- Side effect: Put new arguments into `stonedArgs`
        table.insert(storedArgs, newArgs[i])
      end
      -- Create new closure with previously and newly passed arguments
      return curried(list.unpack(storedArgs))
    end

    return Function:new {
      res,
      nparams = f:get_nparams() - argv.n,
      isvararg = f:is_vararg(),
      raw = f:get_raw()
    }
  end

  return curried()
end

---Currying function `f` with optional number of parameters
---By default, `maxArgc` is the number of arguments `f` expect
---Variadic function must provide nparams
---@param f function | vkzlib.data.Function
---@param nparams integer?
---@return vkzlib.data.Function
local function curry(f, nparams)
  local deferred_errmsg = errmsg("curry")
  -- TODO: Refactor
  local __nparams = nil
  local opts = {}
  if type(f) == "function" then
    local info = debug.getinfo(f)
    opts.isvararg = info.isvararg
    if not opts.isvararg then
      -- Not vararg, retrieve anything
      nparams = core.from_maybe(info.nparams, nparams)
      assert(nparams >= 0 and nparams <= info.nparams,
        deferred_errmsg("nparams out of range")
      )
    else
      -- If isvararg, leave nparams untouched
      -- Let caller decide how many arguments it takes
      -- But nparams must greater or equal than minimal requirement
      assert(type(nparams) == "number",
        deferred_errmsg("nparams is required for vararg function")
      )
      assert(nparams >= info.nparams,
        deferred_errmsg("nparams less than minimal requirement")
      )
    end
  elseif Function.is_function_object(f) then
    -- Almost the same
    opts.isvararg = f:is_vararg()
    if not opts.isvararg then
      nparams = core.from_maybe(f:get_nparams(), nparams)
      assert(nparams >= 0 and nparams <= f:get_nparams(),
        deferred_errmsg("nparams out of range")
      )
    else
      assert(type(nparams) == "number",
        deferred_errmsg("nparams is required for vararg function")
      )
      assert(nparams >= f:get_nparams(),
        deferred_errmsg("nparams less than minimal requirement")
      )
    end
  else
    error(deferred_errmsg("Not a callable") ())
  end

  -- TODO: Use nparams
  -- Actually, figure out what nparams does first
  f = type(f) == "function" and Function:new { f, is_vararg = opts.isvararg } or f:copy(true)

  log.t("curry", "Object passed to _curry", f)

  return _curry(f)
end

-- TODO: `Function` compatibility
-- Use weak table for nparams = 1
-- Expand nparams for positive integer by recursively apply nparams = 1 to decrease nparams

---Make function `f` memorize its result
---@param f function
---@return function
local function memorize(f)
  local deferred_errmsg = errmsg("memorize")
  assert(type(f) == "function" and debug.getinfo(f, "u").nparams == 0,
    deferred_errmsg("only function with no argument can be memorized")
  )
  local function closure()
    local mem = nil
    return function ()
      if mem ~= nil then
        log.t("memorize", "skipped")
        return mem
      end
      mem = f()
      return mem
    end

  end

  return closure()
end

-- TODO: `Function` compatibility

---Apply arguments to function `f`
---@param f function
---@param ... any
---@return any
local function apply(f, ...)
  local deferred_errmsg = errmsg("apply")
  assert(type(f) == "function",
    deferred_errmsg("not a function")
  )
  return f(...)
end

-- TODO: `Function` compatibility

---Compose two functions
---@param f function
---@param g function
---@return function
local function compose(f, g)
  return function (x, ...)
    return f(g(x), ...)
  end
end

-- TODO: `Function` compatibility

---Swap position of first and second argument
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

