local Groups = require("config.key_groups").Groups

return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		require("plugins.libs.plenary"),
		require("plugins.libs.ripgrep"),
	},
	keys = {
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
			Groups.Telescope.lhs .. "li",
			mode = "n",
			"<CMD>Telescope lsp_implementations<CR>",
			desc = "LSP Implementations",
		},
	},
}
