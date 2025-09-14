local profile = require("profiles")

local lsp = require("config.lsp")

---@type LazyPluginSpec
return {
	"neovim/nvim-lspconfig",
  event = "VeryLazy",
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
			lazy = true,
		},
		{
			"antosha417/nvim-lsp-file-operations",
			lazy = true,
		},
		{
			"williamboman/mason.nvim",
			enabled = profile.preference.use_mason == true,
		},
		{
			"b0o/schemastore.nvim",
			lazy = true,
		},
	},
	config = function()
		if profile.preference.use_mason then
			lsp.setup.with_mason(lsp.handle_by_mason, lsp.manual_setup)
		else
			lsp.setup.lspconfig_only(lsp.manual_setup)
		end
	end,
}
