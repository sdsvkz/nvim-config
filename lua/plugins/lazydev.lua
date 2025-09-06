local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local opts = {
	library = {
		-- See https://github.com/folke/lazydev.nvim#%EF%B8%8F-configuration for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		"lazy.nvim",
	},
	integrations = {
		-- Fixes lspconfig's workspace management for LuaLS
		-- Only create a new workspace if the buffer is not part
		-- of an existing workspace or one of its libraries
		lspconfig = true,
		-- add the cmp source for completion of:
		-- `require "modname"`
		-- `---@module "modname"`
		cmp = true,
		-- same, but for Coq
		coq = false,
	},
}

return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	},
}
