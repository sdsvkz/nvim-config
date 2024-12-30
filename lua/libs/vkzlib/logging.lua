local MODULE = "logging"

-- TODO: Looks like callback doesn't have funcinfo. Figure it out.

local internal = require("vkzlib.internal")

local get_logger = internal.logging.get_logger

local function round(x, increment)
  increment = increment or 1
  x = x / increment
  return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
end

local function to_string(...)
  local t = {}
  for i = 1, select('#', ...) do
    local x = select(i, ...)
    if type(x) == "number" then
      x = round(x, .01)
    end
    table.insert(t, tostring(x))
  end
  return table.concat(t, " ")
end

---@param info vkzlib.logging.get_logger.format.Info
---@param ... any
---@return string
local function format(info, ...)
  local nameupper = info.level:upper()
  local msg = to_string(...)
  local lineinfo = info.info.short_src .. ":" .. info.info.currentline
  local funcinfo = info.info.name
    and string.format(" in function `%s`", info.info.name)
    or ""
  return string.format(
    "%s[%-6s%s]%s %s:%s\n%s",
    info.color,
    nameupper,
    os.date("%H:%M:%S"),
    info.color,
    lineinfo,
    funcinfo,
    msg
  )
end

return {
  default_format = format,
  get_logger = get_logger,
  log = {
    std = get_logger( format, {
      print = print,
      with_traceback = true,
    } ),
    -- TODO: This should optionally loaded depends on whether using Neovim
    vim = get_logger( format, {
      print = vim.print,
      with_traceback = true,
    } ),
  }
}
