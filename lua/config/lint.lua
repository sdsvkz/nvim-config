-- Use `nvim-lint.nvim`
local lint = require("lint")
local linters = require("profiles").languages.linters
assert(linters ~= nil, "Profile with invalid linters")

---@class (exact) config.lint.LinterSpec
---@field [1] string
---@field opts fun(linter: lint.Linter?): lint.Linter

---@param linter lint.Linter | fun(): lint.Linter?
---@param opts fun(linter: lint.Linter?): lint.Linter
---@return fun(): lint.Linter
local function get_linter_by_opts(linter, opts)
  return function ()
    if type(linter) == "function" then
      return opts(linter())
    else
      assert(type(linter) == "table" or type(linter) == "nil")
      return opts(linter)
    end
  end
end

local linters_by_ft = Vkzlib.core.deep_copy(linters, true)

for ft, linters_of_ft in pairs(linters) do
  for index, linter in ipairs(linters_of_ft) do
    if type(linter) == "table" then
      assert(type(linter[1]) == "string" and type(linter.opts) == "function", "Invalid LinterSpec")
      --- Register or override linter
      lint.linters[linter[1]] = get_linter_by_opts(lint.linters[linter[1]], linter.opts)
      --- Extract linter name
      linters_by_ft[ft][index] = linter[1]
    end
  end
end

Log.t(Vkzlib.core.to_string(linters_by_ft))

--- Process above should ensure all `LinterSpec`s have been replaced by linter's name
---@cast linters_by_ft table<string, string[]>
lint.linters_by_ft = linters_by_ft

-- Setup autocmd to trigger lint
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    lint.try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("cspell")
  end,
})
