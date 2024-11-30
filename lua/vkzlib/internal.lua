local LIB = "vkzlib"
local VERSION = "0.0.1"

local MODULE = "core"

---@param module string
---@return fun(comp: string): string
local function _get_qualified_name(module)
  local prefix = LIB .. "." .. module .. "."
  return function (comp)
    return prefix .. comp
  end
end

---@param module string
---@return fun(comp: string, msg:string): string
local function _errmsg(module)
  local _f = _get_qualified_name(module)
  return function (comp, msg)
    return _f(comp) .. ": " .. msg
  end
end

local get_qualified_name = _get_qualified_name(MODULE)
local errmsg = _errmsg(MODULE)

local core = {}

-- vkzlib.core

core.to_string = vim.inspect
core.equals = vim.deep_equal
core.copy = vim.deepcopy

-- Return `t` if `b` is true. Otherwise, return nothing
---@param b boolean
---@param t any
---@return any
core.enable_if = function (b, t)
  if b == true then
    return t
  end
end

-- b == true ? t : f
-- Return `t` if `b` is `true`. Otherwise return `f`
---@generic T, U
---@param b boolean
---@param t T
---@param f U
---@return T | U
core.conditional = function (b, t, f)
  if b == true then
    return t
  else
    return f
  end
end

-- Return `m` if `m` is not `nil`. Otherwise, return `a`
---@generic T, U
---@param a U
---@param m T?
---@return T | U
core.from_maybe = function (a, m)
  return core.conditional(m == nil, a, m)
end

-- Return `x` if `x` is type of `t`. Otherwise, return `a`
---@generic T, U
---@param t type
---@param a U
---@param x T?
---@return T | U
core.from_type = function (t, a, x)
  return core.conditional(type(x) == t, x, a)
end

-- Kotlin `let` scope function
---@generic T
---@generic R
---@param it T
---@param block fun(x: T): R
---@return R
core.let = function (it, block)
  return block(it)
end

-- Kotlin `also` scope function
---@generic T
---@generic R
---@param it T
---@param block fun(x: T): R
---@return R
core.also = function (it, block)
  block(it)
  return it
end

-- `true` if all argument is `true`
---@param bs boolean[]
---@return boolean
core.all = function (bs)
  for _, b in ipairs(bs) do
    assert(type(b) == "boolean", errmsg("all", "contains non-boolean argument"))
    if not b then
      return false
    end
  end
  return true
end

-- `true` if any argument is `true`
---@param bs boolean[]
---@return boolean
core.any = function (bs)
  for _, b in ipairs(bs) do
    assert(type(b) == "boolean", errmsg("any", "contains non-boolean argument"))
    if b then
      return true
    end
  end
  return false
end

-- vkzlib.logging

---@alias vkzlib.logging.Logger.Level "trace" | "debug" | "info" | "warn" | "error" | "fatal"

---@type table<vkzlib.logging.Logger.Level, string>
local color_of_levels = {
  { name = "trace", color = "\27[34m", },
  { name = "debug", color = "\27[36m", },
  { name = "info",  color = "\27[32m", },
  { name = "warn",  color = "\27[33m", },
  { name = "error", color = "\27[31m", },
  { name = "fatal", color = "\27[35m", },
}

local levels = {}
for i, v in ipairs(color_of_levels) do
  levels[v.name] = i
end

---@class vkzlib.logging.get_logger.format.Info
---@field level string
---@field info debuginfo
---@field color string

---@class vkzlib.logging.get_logger.Opts
---@field print fun(...: any)
---@field usecolor boolean?
---@field outfile string?
---@field level nil | vkzlib.logging.Logger.Level

---@param format fun(info: vkzlib.logging.get_logger.format.Info, ...: any[])
---@param opts vkzlib.logging.get_logger.Opts?
---@return fun(...: any)
local function get_logger(format, opts)
  ---@type fun(...: any)
  local print = print
  ---@type boolean
  local usecolor = true
  ---@type string?
  local outfile = nil
  ---@type vkzlib.logging.Logger.Level
  local level = "info"

  if type(opts) == "table" then
    print = core.from_type("function", print, opts.print)
    usecolor = core.from_type("boolean", usecolor, opts.usecolor)
    outfile = core.from_type("string", outfile, opts.outfile)
    level = core.from_type("string", level, opts.level)
  end

  local level_num = nil
  local color = nil
  for i, v in ipairs(color_of_levels) do
    if v.name == level then
      level_num = i
      color = v.color
      break
    end
  end

  assert(
    level_num ~= nil and color ~= nil,
    errmsg("get_logger", "failed to get level and color")
  )

  return function(...)

    -- Return early if we're below the log level
    if level_num < levels[LOG_LEVEL] then
      return
    end

    local info = debug.getinfo(2, "Sl")

    -- Output to console
    print(
      format({
        color = usecolor and color or "",
        info = info,
        level = level,
      }, ...)
    )

    -- Log to file
    if type(outfile) == "string" then
      local fp = io.open(outfile, "a")
      assert(fp ~= nil, errmsg("get_logger.return", "failed to open file: " .. outfile))
      fp:write(
        format({
          color = "",
          info = info,
          level = level,
        }, ...)
      )
      fp:close()
    end

  end
end

-- Get logger for module
-- By default, `verbose_only` is `false`
---@param module_name string
---@param level? vkzlib.logging.Logger.Level
---@return fun(comp: string, desc: string, ...)
local function logger(module_name, level)
  local prefix = "vkzlib." .. module_name .. "."

  ---@param info vkzlib.logging.get_logger.format.Info
  ---@vararg any
  local function format(info, ...)
    local lineinfo = info.info.short_src .. ":" .. info.info.currentline
    local str = string.format(
      "[%-6s%s] %s:\n",
      info.level:upper(),
      os.date("%H:%M:%S"),
      lineinfo
    )
    local args = { n = select("#", ...), ... }
    for i = 1, args.n do
      str = str .. core.to_string(args[i]) .. "\n"
    end
    return str
  end

  local function _logger()
    local log = get_logger(format, {
      print = vim.print,
      level = level,
      usecolor = false,
    })
    return function (comp, desc, ...)
      log(prefix .. comp, desc, ...)
    end
  end

  return _logger()
end

-- vkzlib.list

-- Returns a new table with all arguments stored into keys `1`, `2`, etc
-- and with a field `"n"` with the total number of arguments
---@vararg any
---@return List
---@see table.pack
local function pack(...)
  return { n = select("#", ...), ... }
end

core.pack = table.pack or pack

local _unpack = unpack

-- Returns the elements from the given `list`. This function is equivalent to
-- ```lua
--     return t[i], t[i+1], ..., t[j]
-- ```
---@generic T
---@param t List
---@param i integer?
---@param j integer?
---@return T ...
function unpack(t, i, j)
  if j or type(t) ~= "table" or t.n == nil or (i and type(i) ~= "number") then
    -- Let _unpack handle exceptions as well
    ---@diagnostic disable-next-line: param-type-mismatch
    return _unpack(t, i, j)
  end
  return _unpack(t, core.from_maybe(1, i), t.n)
end

core.unpack = table.unpack or unpack

-- Apply function to list elements
---@generic T
---@generic R
---@param f fun(x: T): R
---@param xs T[]
---@return R[]
core.map = function (f, xs)
  local res = {}
  for i, x in ipairs(xs) do
    res[i] = f(x)
  end
  return res
end

-- vkzlib.str

local join = table.concat

core.join = join

-- vkzlib.typing

-- If type of `x` is any of vararg
---@param x any
---@vararg type
---@return boolean
core.is_type = function (x, ...)
  local type_x = type(x)
  return core.any( core.map( function (t)
    return type_x == t
  end, {...} ) )
end

-- Throw if type of `x` is not `t`
---@param x any
---@vararg type
core.ensure_type = function (x, ...)
  assert(core.is_type(x, ...), errmsg(
    "ensure_type", "type " .. type(x) .. " but requires any of " .. core.to_string({...}))
  )
end

-- If `x` is an object and is callable
---@param x any
---@return boolean
core.is_callable_object = function (x)
  if not core.is_type(x, "table") then
    return false
  end

  local mt = getmetatable(x)
  if mt and core.is_type(mt.__call, "function") then
    return true
  end
  return false
end

-- If `x` is callable
---@param x any
---@return boolean
core.is_callable = function (x)
  if core.is_type(x, "function") then
    return true
  end

  return core.is_callable_object(x)
end

-- vkzlib.table

local table_map = vim.tbl_map

return {
  _lib_name = LIB,
  _version = VERSION,

  logger = logger,
  get_qualified_name = _get_qualified_name,
  errmsg = _errmsg,

  core = core,

  logging = {
    get_logger = get_logger,
  },

  list = {
    pack = core.pack,
    unpack = core.unpack,
    map = core.map,
  },

  table = {
    map = table_map,
  },

  typing = {
    is_type = core.is_type,
    ensure_type = core.ensure_type,
    is_callable = core.is_callable,
    is_callable_object = core.is_callable_object,
  },

  str = {
    join = core.join,
  },
}
