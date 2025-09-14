local profile = require("profiles")

local Groups = require("config.key_groups").Groups

---@module "mason"

---@type MasonSettings
local opts = {}

---@type LazyPluginSpec[]
return {
	{
		"williamboman/mason.nvim",
		enabled = profile.preference.use_mason == true,
		event = "VeryLazy",
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
}
