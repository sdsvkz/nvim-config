local profile = require("profiles")

---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			enabled = profile.preference.use_mason == true,
		},
		{
			"b0o/schemastore.nvim",
			lazy = true,
		},
	},
}
