local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local Groups = require("config.key_groups").Groups

---enables autocomplete for opts
---@module "auto-session"
---@type AutoSession.Config
local opts = {
  suppressed_dirs = { "~/", "/", [[C:\Users\*]] },
  bypass_save_filetypes = { "alpha", "dashboard" },
  -- log_level = 'debug',
}

return {
	"rmagatti/auto-session",
	lazy = false,
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	init = function()
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
	keys = {
		{
			Groups.UI.lhs .. "s",
			mode = "n",
			"<CMD>AutoSession search<CR>",
			desc = "Search for sessions",
		},
	},
}
