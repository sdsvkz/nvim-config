local internal = require("vkzlib.internal")
local core = internal.core
local LazyValue = internal.Data.LazyValue

local errmsg = internal.errmsg("io.lua")

---Get the path of caller module
---This function is implemented with `debug.getinfo(2, "S")`
---which relies on certain depth of call stack to function correctly
---Don't call this in a function that may execute outside of the module
---@return string
local function get_caller_module_path()
  local deferred_errmsg = errmsg("get_caller_module_path")
  local path = debug.getinfo(2, "S").source:sub(2)
  core.assert(type(path) == "string", LazyValue:new(function ()
    return deferred_errmsg("path is not string: " .. core.to_string(path)):toStrict()
  end))
  return path
end

---Get the name of caller module
---This function is implemented with `debug.getinfo(2, "S")`
---which relies on certain depth of call stack to function correctly
---Don't call this in a function that may execute outside of the module
---@return string
local function get_caller_module_name()
  local deferred_errmsg = errmsg("get_caller_module_name")
  local path = debug.getinfo(2, "S").source:sub(2)
  core.assert(type(path) == "string", LazyValue:new(function ()
    return deferred_errmsg("path is not string: " .. core.to_string(path)):toStrict()
  end))
  local module_name = path:match("([^/\\]+)%.lua$")
  core.assert(type(module_name) == "string", LazyValue:new(function ()
    return deferred_errmsg("Not a path: " .. path):toStrict()
  end))
  ---@cast module_name string
  return module_name
end

---Check if a module exists
---@param MODULE_PATH string
local function is_module_exists(MODULE_PATH)
	if package.loaded[MODULE_PATH] then
		return true
	end
	---@diagnostic disable-next-line: deprecated
	for _, searcher in ipairs(package.searchers or package.loaders) do
    if type(searcher(MODULE_PATH)) == "function" then
      return true
    end
	end
  return false
end

return {
  get_caller_module_path = get_caller_module_path,
  get_caller_module_name = get_caller_module_name,
  is_module_exists = is_module_exists,
}

