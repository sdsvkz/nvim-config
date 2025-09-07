local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local Groups = require("config.key_groups").Groups

---@module "mcphub"

---@type MCPHub.Config
local opts = {}

---@type LazyPluginSpec
return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
	cmd = "MCPHub",
	keys = {
		{
			Groups.Setting.lhs .. "h",
			mode = "n",
			"<CMD>MCPHub<CR>",
			desc = "Open MCPHub Panel",
		},
	},
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
