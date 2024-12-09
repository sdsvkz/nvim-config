local LIB = "vkzlib"
local VERSION = "0.0.1"

local MODULE = "core"

---@param module string
---@return fun(component: string): string
local function get_qualified_name_(module)
  local prefix = LIB .. "." .. module .. "."
  return function (component)
    return prefix .. component
  end
end

---@param module string
---@return fun(component: string): fun(msg: string): fun(): string
local function errmsg_(module)
  local get_prefix = get_qualified_name_(module)
  return function (component)
    local prefix = get_prefix(component)
    return function (msg)
      local res = prefix .. ": " .. msg
      return function ()
        return res
      end
    end
  end
end

---Assert with lazy message evaluation
---
---Raises an error if the value of its argument v is false (i.e., `nil` or `false`)
---otherwise, returns all its arguments. In case of error, `message` is the error object; when absent, it defaults to `"assertion failed!"`
---
---[View documents](http://www.lua.org/manual/5.1/manual.html#pdf-assert)
---
---Pain as fuck to write lambda every time I call this
---But I think it is the only way to evaluate argument lazily
---
---@generic T
---@param v? T
---@param get_msg? fun(): any
---@param ... any
---@return T
---@return any ...
local function assert_(v, get_msg, ...)
  if v == false or v == nil then
    error(get_msg and get_msg() or "assertion failed!")
  end
  return v, get_msg, ...
end

local get_qualified_name = get_qualified_name_(MODULE)
local errmsg = errmsg_(MODULE)
local assert = assert_

local core = {}

-- vkzlib.core

core.to_string = vim.inspect -- TODO: Implement this
core.equals = vim.deep_equal -- TODO: Implement this
core.copy = vim.deepcopy -- TODO: Implement this

-- Return `t` if `b` is true. Otherwise, return nothing
---@param b boolean
---@param t any
---@return any
core.enable_if = function (b, t)
  if b == true then
    return t
  end
end

-- TODO:
-- Implement lazy version of those functions

---b == true ? t : f
---Return `t` if `b` is `true`. Otherwise return `f`
---!!! This function doesn't lazy evaluate its arguments
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
  local deferred_errmsg = errmsg("all")
  for _, b in ipairs(bs) do
    assert(type(b) == "boolean", deferred_errmsg("contains non-boolean argument"))
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
  local deferred_errmsg = errmsg("any")
  for _, b in ipairs(bs) do
    assert(type(b) == "boolean",  deferred_errmsg("contains non-boolean argument"))
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
---@field print fun(...: any) Print function used to print message
---@field with_traceback boolean? Append call stack traceback to message (Default `false`)
---@field usecolor boolean? Print with color (Default `true`)
---@field outfile string? Also write logs into `outfile` (Default `nil`, means don't)
---@field level vkzlib.logging.Logger.Level? Log level of this logger (Default `info`)
---@field depth integer? Depth of call stack for `debug.getinfo` (Default `2`)

---@param format fun(info: vkzlib.logging.get_logger.format.Info, ...: ...)
---@param opts vkzlib.logging.get_logger.Opts?
---@return fun(...: any)
---
---@see vkzlib.logging.get_logger.Opts
---@see vkzlib.logging.get_logger.format.Info
local function get_logger(format, opts)
  local deferred_errmsg = errmsg("get_logger")
  ---@type fun(...: any)
  local print = print
  ---@type boolean
  local with_traceback = false
  ---@type boolean
  local usecolor = true
  ---@type string?
  local outfile = nil
  ---@type vkzlib.logging.Logger.Level
  local level = "info"
  ---@type integer
  local depth = 2

  if type(opts) == "table" then
    print = core.from_type("function", print, opts.print)
    with_traceback = core.from_type("boolean", with_traceback, opts.with_traceback)
    usecolor = core.from_type("boolean", usecolor, opts.usecolor)
    outfile = core.from_type("string", outfile, opts.outfile)
    level = core.from_type("string", level, opts.level)
    depth = core.from_type("number", depth, opts.depth)
  end

  ---@type integer
  local level_num = nil
  ---@type string
  local color = nil
  for i, v in ipairs(color_of_levels) do
    if v.name == level then
      level_num = i
      color = v.color
      break
    end
  end

  assert(level_num ~= nil and color ~= nil, deferred_errmsg("failed to get level and color"))

  return function(...)
    local deferred_errmsg_return = errmsg("get_logger.return")

    -- Return early if we're below the log level
    if level_num < levels[LOG_LEVEL] then
      return
    end

    local info = debug.getinfo(depth, "Sln")
    assert(core.is_type(info, "table"))

    local res = format({
      color = usecolor and color or "",
      info = info,
      level = level,
    }, ...)

    -- Output to console
    if with_traceback == true then
      print(
        debug.traceback(res, depth + 1) .. "\n"
        .. "\n"
        .. "====================================================================================" .. "\n"
      )
    else
      print(res)
    end

    -- Log to file
    if type(outfile) == "string" then
      local fp = io.open(outfile, "a")
      assert(fp ~= nil, deferred_errmsg_return("failed to open file: " .. outfile))
      fp:write(
        format({
          color = "",
          info = info,
          level = level
        }, ...)
      )
      fp:close()
    end

  end
end

-- Get logger for module
-- By default, `verbose_only` is `false`
---@param module_name string
---@param level vkzlib.logging.Logger.Level?
---@param depth integer?
---@return fun(comp: string, desc: string, ...)
local function logger(module_name, level, depth)
  local prefix = "vkzlib." .. module_name .. "."

  ---@param info vkzlib.logging.get_logger.format.Info
  ---@param ... any
  local function format(info, ...)
    local lineinfo = info.info.short_src .. ":" .. info.info.currentline
    local funcinfo = info.info.name
      and string.format(" in function `%s`", info.info.name)
      or ""
    local str = string.format(
      "[%-6s%s] %s:%s\n",
      info.level:upper(),
      os.date("%H:%M:%S"),
      lineinfo,
      funcinfo
    )
    local args = { n = select("#", ...), ... }
    for i = 1, args.n do
      str = str .. core.to_string(args[i]) .. "\n"
    end
    return str
  end

  local function _logger()
    local log = get_logger(format, {
      print = vim.print, -- TODO: Use others if not using Neovim
      with_traceback = LOG_LEVEL == "trace",
      usecolor = false,
      level = level,
      depth = depth,
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
---@param ... any
---@return { [integer]: any, n: integer }
---
---@see table.pack
local function pack(...)
  return { n = select("#", ...), ... }
end

core.pack = table.pack or pack

-- Recursive part of `v_unpack`
local function _v_unpack(t, i, j)
  if i > j then
    return
  else
    return t[i], _v_unpack(t, i+1, j)
  end
end

-- Returns the elements from the given `list`. This function is equivalent to
-- ```lua
--     return t[i], t[i+1], ..., t[j]
-- ```
---@param list any[]
---@param first integer? Index of first element (Default `1`)
---@param last integer? Index of last element (Default `#t`)
---@return any ...
local function v_unpack(list, first, last)
  local deferred_errmsg = errmsg("v_unpack")
  assert(type(list) == "table", deferred_errmsg("bad argument #1 (table expected, got " .. type(list) .. ")"))

  local function get_integer(x, name, default)
    if x then
      assert(type(x) == "number",
        deferred_errmsg("bad argument " .. name .. " (number expected, got " .. type(x) .. ")")
      )
      return x < 0 and math.ceil(x) or math.floor(x)
    else
      return default
    end
  end

  return _v_unpack(list, get_integer(first, "#2", 1), get_integer(last, "#3", #list))
end

core.unpack = table.unpack or unpack or v_unpack

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

-- Whether type of `x` is any of vararg
---@param x any
---@param ... type
---@return boolean
core.is_type = function (x, ...)
  local type_x = type(x)
  return core.any( core.map( function (t)
    return type_x == t
  end, {...} ) )
end

-- Throw if type of `x` is not `t`
---@param x any
---@param ... type
core.ensure_type = function (x, ...)
  local deferred_errmsg = errmsg("ensure_type")
  -- Shitty lua can't naming `...` so it is not inherited into inner function
  -- I have to store those things
  local args = core.pack(...)
  assert(core.is_type(x, ...), deferred_errmsg(
    "type " .. type(x) ..
    " but requires any of " .. core.to_string(args)
  ))
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

local tbl_map = vim.tbl_map

return {
  _lib_name = LIB,
  _version = VERSION,

  logger = logger,
  get_qualified_name = get_qualified_name_,
  errmsg = errmsg_,
  assert = assert_,

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
    map = tbl_map,
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
