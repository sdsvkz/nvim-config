local merge_plugin_opts = require("profiles.utils").merge_plugin_opts
local deep_merge = Vkz.vkzlib.Data.table.deep_merge
local Groups = require("config.key_groups").Groups

local opts = function(_, o)
	return deep_merge("force", o, {
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({}),
			},
		},
	})
end

---@type LazyPluginSpec
return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	config = function(_, o)
		require("telescope").setup(o)
		require("telescope").load_extension("ui-select")
	end,
	keys = {
		{
			Groups.Telescope.lhs .. "f",
			mode = "n",
			"<CMD>Telescope find_files<CR>",
			desc = "Search for file",
		},
		{
			Groups.Telescope.lhs .. "g",
			mode = "n",
			"<CMD>Telescope live_grep<CR>",
			desc = "Live grep",
		},
		{
			Groups.Telescope.lhs .. "n",
			mode = "n",
			"<CMD>Telescope noice<CR>",
			desc = "Notifications",
		},
		{
			Groups.Telescope.lhs .. "N",
			mode = "n",
			"<CMD>Telescope notify<CR>",
			desc = "Notify",
		},
		{
			Groups.Telescope.lhs .. "x",
			mode = "n",
			"<CMD>Telescope diagnostics<CR>",
			desc = "Diagnostics",
		},
		{
			Groups.Telescope.lhs .. "lr",
			mode = "n",
			"<CMD>Telescope lsp_references<CR>",
			desc = "LSP References",
		},
		{
			Groups.Telescope.lhs .. "ld",
			mode = "n",
			"<CMD>Telescope lsp_definitions<CR>",
			desc = "LSP Definitions",
		},
		{
			Groups.Telescope.lhs .. "lt",
			mode = "n",
			"<CMD>Telescope lsp_type_definitions<CR>",
			desc = "LSP Type definitions",
		},
		{
			Groups.Telescope.lhs .. "li",
			mode = "n",
			"<CMD>Telescope lsp_implementations<CR>",
			desc = "LSP Implementations",
		},
	},
}
