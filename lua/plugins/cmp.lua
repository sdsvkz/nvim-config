return {
	{
		"hrsh7th/nvim-cmp",
    event = "InsertEnter",
		dependencies = {
			require("plugins.lspconfig"),
      require("plugins.luaSnip"),
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
      { "petertriho/cmp-git", dependencies = { require("plugins.libs.plenary") }, opts = {} },
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"lukas-reineke/cmp-under-comparator",
    event = "InsertEnter",
	},
}
