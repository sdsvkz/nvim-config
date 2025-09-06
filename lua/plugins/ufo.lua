local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local ufo = function()
	return require("ufo")
end

local opts = {}

return {
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	event = "UIEnter",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	init = function()
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
	end,
	keys = function()
		return {
			{
				"zR",
				mode = "n",
				function()
					ufo().openAllFolds()
				end,
				desc = "Open all folds",
			},
			{
				"zM",
				mode = "n",
				function()
					ufo().closeAllFolds()
				end,
				desc = "Close all folds",
			},
		}
	end,
}
