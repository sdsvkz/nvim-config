local MODULE = "logging"

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
    t[#t + 1] = tostring(x)
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
  return string.format(
    "%s[%-6s%s]%s %s: %s",
    info.color,
    nameupper,
    os.date("%H:%M:%S"),
    info.color,
    lineinfo,
    msg
  )
end

return {
  get_logger = get_logger,
  log = {
    std = get_logger( format ),
    -- TODO This should optionally loaded depends on whether using Neovim
    vim = get_logger( format, {
      print = vim.print,
    } ),
  }
}
