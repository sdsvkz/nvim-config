local formatters = require("config.formatters")

return {
	"stevearc/conform.nvim",
  main = "conform",
  opts = {
    formatters_by_ft = formatters
  },
	init = function()
		local conform = require("conform")
		-- Keymap
		vim.keymap.set("n", "<LEADER>f", conform.format, { desc = "Conform: Format file" })
	end,
}
