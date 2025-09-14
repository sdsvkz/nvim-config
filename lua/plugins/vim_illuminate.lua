local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {
	delay = 200,
	large_file_cutoff = 2000,
	large_file_overrides = {
		providers = {
			"lsp",
			"treesitter",
			"regex",
		},
	},
	under_cursor = true,
}

return {
	"RRethy/vim-illuminate",
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	---@type LazyKeysSpec[]
	keys = {
		{
			"<A-n>",
			mode = "n",
			desc = "Move to next reference",
		},
		{
			"<A-p>",
			mode = "n",
			desc = "Move to previous reference",
		},
	},
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	config = function(_, o)
		require("illuminate").configure(o)
	end,
}
