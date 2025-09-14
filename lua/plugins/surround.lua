local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {}

return {
	"kylechui/nvim-surround",
	event = "VeryLazy",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
