local Groups = require("config.key_groups").Groups
local formatters = require("profiles").languages.formatters
assert(formatters ~= nil, "Profile with invalid formatters")

return {
	"stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  main = "conform",
  opts = {
    formatters_by_ft = formatters
  },
	init = function()
		local conform = require("conform")
		-- Keymap
		vim.keymap.set("n", Groups.Editing.lhs .. "f", conform.format, { desc = "Conform: Format file" })
	end,
}
