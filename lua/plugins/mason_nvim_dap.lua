local profile = require("profiles")

---@module "mason-nvim-dap"

---@type MasonNvimDapSettings
---@diagnostic disable-next-line: missing-fields
local opts = {}

---@type LazyPluginSpec
return {
	"jay-babu/mason-nvim-dap.nvim",
	enabled = profile.preference.use_mason == true,
  event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	opts = profile.utils.merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
