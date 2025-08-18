local profile = require("profiles")

if profile.preference.use_mason == false then
	return {}
end

local Groups = require("config.key_groups").Groups
return {
	{
		"williamboman/mason.nvim",
		opts = {},
		keys = {
			{
				Groups.Setting.lhs .. "m",
				mode = "n",
				"<CMD>Mason<CR>",
				desc = "Mason home",
			},
		},
	},
	require("plugins.mason.dap"),
	require("plugins.mason.lspconfig"),
	require("plugins.mason.tool_installer"),
}
