local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	--
	presets = {
		bottom_search = false, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true, -- add a border to hover docs and signature help
	},
}

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	config = function(_, o)
		require("noice").setup(o)
		require("telescope").load_extension("noice")
	end,
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",

		-- OPTIONAL:
		--   `nvim-treesitter` used for highlighting the cmdline and lsp docs.
		--   Make sure to install the parsers for vim, regex, lua, bash, markdown and markdown_inline
		"nvim-treesitter/nvim-treesitter",

		-- Telescope integration
		"nvim-telescope/telescope.nvim",
	},
}
