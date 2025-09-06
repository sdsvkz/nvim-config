local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local function flash()
	return require("flash")
end

---@type Flash.Config
local opts = {}

return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				flash().jump()
			end,
			desc = "Flash",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				flash().treesitter()
			end,
			desc = "Flash Treesitter",
		},
		{
			"r",
			mode = "o",
			function()
				flash().remote()
			end,
			desc = "Remote Flash",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				flash().treesitter_search()
			end,
			desc = "Treesitter Search",
		},
		{
			"<c-s>",
			mode = { "c" },
			function()
				flash().toggle()
			end,
			desc = "Toggle Flash Search",
		},
	},
}
