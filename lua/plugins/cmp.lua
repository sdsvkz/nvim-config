return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			require("plugins.lspconfig"),
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			require("plugins.luaSnip"),
		},
	},
	{
		"lukas-reineke/cmp-under-comparator",
	},
}
