local profile = require("profiles")

local opts = {
	editor = {
		tooltip = "The most beautiful clusterfuck in the world",
	},
}

---@type LazyPluginSpec
return {
	"vyfor/cord.nvim",
	enabled = profile.preference.enable_discord_rich_presence,
	build = ":Cord update",
	opts = profile.utils.merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
