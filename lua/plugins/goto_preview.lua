local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local Groups = require("config.key_groups").Groups

local function preview()
	return require("goto-preview")
end

local opts = {
	force_close = true,
	focus_on_open = true,
	preview_window_title = {
		position = "center",
	},
}

function opts.post_open_hook(buf, win)
	vim.keymap.set("n", "q", function()
		preview().dismiss_preview(win)
	end, { buffer = buf, desc = "Close preview" })
end

---@type LazyPluginSpec
return {
	"rmagatti/goto-preview",
	dependencies = { "rmagatti/logger.nvim" },
	event = "BufEnter",
	keys = {
		{
			Groups.Peek.lhs .. "d",
			mode = "n",
			function()
				preview().goto_preview_definition({})
			end,
			desc = "Peek definition",
			noremap = true,
		},
		{
			Groups.Peek.lhs .. "D",
			mode = "n",
			function()
				preview().goto_preview_declaration({})
			end,
			desc = "Peek declaration",
			noremap = true,
		},
		{
			Groups.Peek.lhs .. "t",
			mode = "n",
			function()
				preview().goto_preview_type_definition({})
			end,
			desc = "Peek type definition",
			noremap = true,
		},
		{
			Groups.Peek.lhs .. "r",
			mode = "n",
			function()
				preview().goto_preview_references({})
			end,
			desc = "Peek reference",
			noremap = true,
		},
		{
			Groups.Peek.lhs .. "i",
			mode = "n",
			function()
				preview().goto_preview_implementation({})
			end,
			desc = "Peek implementations",
			noremap = true,
		},
	},
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts), -- necessary as per https://github.com/rmagatti/goto-preview/issues/88
}
