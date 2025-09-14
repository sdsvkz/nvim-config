local profile = require("profiles")

local linters = require("profiles").languages.linters
assert(type(linters) == "table", "Profile with invalid linters")

---@class (exact) config.lint.LinterConfig
---@field ensure_installed config.mason.InstallConfig[]
---@field linters table<string, fun(linter: lint.Linter?): lint.Linter>
---@field linters_by_ft table<string, string[]>

---@class (exact) config.lint.LinterSpec : MasonInstallConfig
---@field opts (fun(linter: lint.Linter?): lint.Linter)?

---@param linter lint.Linter | fun(): lint.Linter?
---@param opts fun(linter: lint.Linter?): lint.Linter
---@return fun(): lint.Linter
local function get_linter_by_opts(linter, opts)
	return function()
		if type(linter) == "function" then
			return opts(linter())
		end
		assert(type(linter) == "table" or type(linter) == "nil")
		return opts(linter)
	end
end

---@param LINTERS table<string, fun(LINTER: lint.Linter?): lint.Linter>
---@param LINTERS_BY_FT table<string, string[]>
local function setup(LINTERS, LINTERS_BY_FT)
	local lint = require("lint")
	--- Register or override linters
	for NAME, LINTER in pairs(LINTERS) do
		lint.linters[NAME] = get_linter_by_opts(lint.linters[NAME], LINTER)
	end

	--- Set linters for every filetype
	lint.linters_by_ft = LINTERS_BY_FT

	-- Setup autocmd to trigger lint
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		callback = function()
			-- try_lint without arguments runs the linters defined in `linters_by_ft`
			-- for the current filetype
			lint.try_lint()

			-- You can call `try_lint` with a linter name or a list of names to always
			-- run specific linters, independent of the `linters_by_ft` configuration
			-- require("lint").try_lint("cspell")
		end,
	})
end

---@type config.lint.LinterConfig
local M = {
  setup = setup,
	ensure_installed = {},
	linters_by_ft = {},
	linters = {},
}

local res = profile.utils.extract_required_linters(linters)

if profile.preference.use_mason then
	M.ensure_installed = res.ensure_installed
end

M.linters = res.linters
M.linters_by_ft = res.linters_by_ft

return M
