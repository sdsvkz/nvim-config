local profile = require("profiles")

local Groups = require("config.key_groups").Groups

local enabled = profile.preference.use_mason == true

local opts = {}

---@type LazyPluginSpec[]
return {
	{
		"williamboman/mason.nvim",
		enabled = enabled,
		lazy = true,
		opts = profile.utils.merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonLog",
			"MasonUpdate",
			"MasonUninstall",
			"MasonUninstallAll",
		},
		keys = {
			{
				Groups.Setting.lhs .. "m",
				mode = "n",
				"<CMD>Mason<CR>",
				desc = "Mason home",
			},
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		enabled = enabled,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		enabled = enabled,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		enabled = enabled,
	},
}
