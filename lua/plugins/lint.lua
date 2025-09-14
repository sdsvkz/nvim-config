local lint = require("config.lint")

return {
	"mfussenegger/nvim-lint",
	main = "lint",
	events = { "BufWritePost", "BufReadPost", "InsertLeave" },
	config = function()
		lint.setup(lint.linters, lint.linters_by_ft)
	end,
}
