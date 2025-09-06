local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {
	backend = "vim",
  picker = "telescope",

  signs = {
    quickfix = { "", { link = "DiagnosticWarning" } },
    others = { "", { link = "DiagnosticWarning" } },
    refactor = { "", { link = "DiagnosticInfo" } },
    ["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
    ["refactor.extract"] = { "", { link = "DiagnosticError" } },
    ["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
    ["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
    ["source"] = { "", { link = "DiagnosticError" } },
    ["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
    ["codeAction"] = { "", { link = "DiagnosticWarning" } },
  },
}

---@type LazyPluginSpec
return {
  "rachartier/tiny-code-action.nvim",
  enabled = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- optional picker via telescope
		"nvim-telescope/telescope.nvim",
	},
	event = "LspAttach",
	keys = {
		{
			"<A-CR>",
			mode = "n",
			function()
				require("tiny-code-action").code_action({})
			end,
			desc = "Code action in cursor",
			noremap = true,
			silent = true,
		},
	},
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
