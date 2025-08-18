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
			Groups.Telescope.lhs .. "x",
			mode = "n",
			"<CMD>Telescope diagnostics<CR>",
			desc = "Diagnostics (Telescope)",
		},
		{
			Groups.Telescope.lhs .. "lr",
			mode = "n",
			"<CMD>Telescope lsp_references<CR>",
			desc = "LSP References (Telescope)",
		},
		{
			Groups.Telescope.lhs .. "ld",
			mode = "n",
			"<CMD>Telescope lsp_definitions<CR>",
			desc = "LSP Definitions (Telescope)",
		},
		{
			Groups.Telescope.lhs .. "li",
			mode = "n",
			"<CMD>Telescope lsp_implementations<CR>",
			desc = "LSP Implementations (Telescope)",
		},
	},
}
