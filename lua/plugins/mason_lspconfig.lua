local profile = require("profiles")

---@module "mason-lspconfig"

---@type MasonLspconfigSettings
local opts = {
	ensure_installed = {},
	automatic_enable = false,
	automatic_installation = false,
}

---@type LazyPluginSpec
return {
	"mason-org/mason-lspconfig.nvim",
	enabled = profile.preference.use_mason == true,
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = profile.utils.merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
