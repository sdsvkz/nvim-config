local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {
	completions = { lsp = { enabled = true } },
}

return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
	dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
	},
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
