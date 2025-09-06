local merge_plugin_opts = require("profiles.utils").merge_plugin_opts
local Groups = require("config.key_groups").Groups

local opts = {
	open_mapping = "<LEADER>wt",
	-- direction = 'float'
	insert_mappings = false,
}

local lazygit = (function()
	local res = nil
	return function()
		if res ~= nil then
			return res
		end
		local Terminal = require("toggleterm.terminal").Terminal
		local lazygit = Terminal:new({
			cmd = "lazygit",
			hidden = true,
			direction = "float",
		})
		res = lazygit
		return res
	end
end)()

---@type LazyPluginSpec
return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	keys = {
		{
			Groups.UI.lhs .. "g",
			mode = { "n", "t" },
			function()
				lazygit():toggle()
			end,
			desc = "Toggle Lazygit session",
			buffer = 0,
			noremap = true,
			silent = true,
		},
		{
			[[<C-/>]],
			mode = { "t" },
			[[<C-\><C-n>]],
			desc = "Switch back to normal mode",
			buffer = 0,
			noremap = true,
			silent = true,
		},
		{
			"<C-h>",
			mode = { "t" },
			"<CMD>wincmd h<CR>",
			desc = "Go to the left window",
			buffer = 0,
			noremap = true,
			silent = true,
		},
		{
			"<C-j>",
			mode = { "t" },
			"<CMD>wincmd j<CR>",
			desc = "Go to the down window",
			buffer = 0,
			noremap = true,
			silent = true,
		},
		{
			"<C-k>",
			mode = { "t" },
			"<CMD>wincmd k<CR>",
			desc = "Go to the up window",
			buffer = 0,
			noremap = true,
			silent = true,
		},
		{
			"<C-l>",
			mode = { "t" },
			"<CMD>wincmd l<CR>",
			desc = "Go to the right window",
			buffer = 0,
			noremap = true,
			silent = true,
		},
		{
			"<c-w>",
			mode = { "t" },
			[[<C-\><C-n><C-w>]],
			desc = "window",
			buffer = 0,
			noremap = true,
			silent = true,
		},
	},
}
