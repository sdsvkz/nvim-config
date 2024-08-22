return {
	"stevearc/conform.nvim",
  main = "conform",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			-- python = { "isort", "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			-- rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
		},
	},
	init = function()
		local conform = require("conform")
		-- Keymap
		vim.keymap.set("n", "<LEADER>f", conform.format, { desc = "Conform: Format file" })
	end,
}
