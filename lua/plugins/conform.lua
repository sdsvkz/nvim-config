local merge_plugin_opts = require("profiles.utils").merge_plugin_opts
local Groups = require("config.key_groups").Groups
local formatters = require("profiles").languages.formatters
assert(formatters ~= nil, "Profile with invalid formatters")

local function conform()
	return require("conform")
end

local opts = {
	formatters_by_ft = formatters,
}

---@type LazyPluginSpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	main = "conform",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	keys = {
		{
			Groups.Editing.lhs .. "f",
			mode = "n",
			function()
				conform().format()
			end,
			desc = "Conform: Format file",
		},
	},
}
