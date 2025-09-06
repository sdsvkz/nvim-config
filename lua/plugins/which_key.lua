local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
	preset = "classic",
}

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
