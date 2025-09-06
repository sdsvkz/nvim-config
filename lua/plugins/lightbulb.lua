local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {
	hide_in_unfocused_buffer = true,
	link_highlights = true,
	code_lenses = true,
	autocmd = {
		enabled = true,
	},
	sign = {
		enabled = true,
		-- Text to show in the sign column.
		-- Must be between 1-2 characters.
		text = "💡",
		lens_text = "🔎",
		-- Highlight group to highlight the sign column text.
		hl = "LightBulbSign",
	},
}

return {
	"kosayoda/nvim-lightbulb",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
