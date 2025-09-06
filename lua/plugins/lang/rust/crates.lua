local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

---@module "crates"

---@type crates.UserConfig
local opts = {
	completion = {
		crates = {
			enabled = true,
		},
	},
	lsp = {
		enabled = true,
		actions = true,
		completion = true,
		hover = true,
	},
}

return {
	"Saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
