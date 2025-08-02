local MODULE = "io.file"

---Try open the file and do something
---@generic R1, R2
---@param on_open fun(file: file*): R1 Called if success
---@param on_fail fun(errmsg: string): R2 Called if failed
---@param FILE_PATH string Path to file
---@param MODE openmode Mode of open
---@return R1 | R2 result returned by `on_open` or `on_fail`
local function with_file_do_either(on_open, on_fail, FILE_PATH, MODE)
	local file, errmsg = io.open(FILE_PATH, MODE)
	if file then
		return on_open(file)
	else
		return on_fail(errmsg or "No error message provided")
	end
end

---Try open the file and do something
---@generic T
---@param on_open fun(file: file*): T Called if success
---@param on_fail fun(errmsg: string): T Called if failed
---@param FILE_PATH string Path to file
---@param MODE openmode Mode of open
---@return T result returned by `on_open` or `on_fail`
local function with_file_do(on_open, on_fail, FILE_PATH, MODE)
  return with_file_do_either(on_open, on_fail, FILE_PATH, MODE)
end

---Read the whole file as `string`
---@param FILE_PATH string
---@return { content: string?, errmsg: string? }
local function read_file(FILE_PATH)
  return with_file_do(
    function (file)
      return { content = file:read("*a") }
    end,
    function (errmsg)
      return { errmsg = errmsg }
    end,
    FILE_PATH,
    "r"
  )
end

local function write_file(FILE_PATH, CONTENT)
  return with_file_do(
    function (file)
      file:write(CONTENT)
      return true
    end,
    function ()
      return false
    end,
    FILE_PATH,
    "w"
  )
end

return {
  with_file_do_either = with_file_do_either,
  with_file_do = with_file_do,
  read_file = read_file,
  write_file = write_file,
}

