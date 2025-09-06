local profile = require("profiles")
local merge_plugin_opts = profile.utils.merge_plugin_opts

---@module "bufferline"

---@type bufferline.UserConfig
local opts = {
	options = {
		show_close_icon = false,
		show_buffer_close_icons = false,
		always_show_bufferline = true,
		indicator = {
			style = "none",
		},
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(_, _, diagnostics_dict, _)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				---@cast e "error" | "warning" | "info" | "hint"
        ---@type " " | " " | " " | " "
				local sym = " "
				if e == "error" then
					sym = " "
				elseif e == "warning" then
					sym = " "
				elseif e == "info" then
					sym = " "
				end
				s = s .. n .. sym
			end
			return s
		end,
		groups = {
			options = {
				toggle_hidden_on_enter = true,
			},
			items = {},
		},
		offsets = {
			{
				filetype = "Nvimtree",
				text = "File Explorer",
				highlight = "Directory",
				separator = true,
				text_align = "center",
			},
		},
	},
}

---@type LazyPluginSpec
return {
	"akinsho/bufferline.nvim",
	dependencies = {
		{
			"catppuccin/nvim",
			enabled = profile.appearence.theme.colorscheme:find("catppuccin") ~= nil,
		},
	},
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
