local profile = require("profiles")

local opts = {
	init = function()
		-- Require providers
		require("hover.providers.lsp")
		require("hover.providers.gh")
		require("hover.providers.gh_user")
		-- require('hover.providers.jira')
		-- require('hover.providers.dap')
		require("hover.providers.fold_preview")
		require("hover.providers.diagnostic")
		-- require('hover.providers.man')
		-- require('hover.providers.dictionary')
	end,
	preview_opts = {
		border = "single",
	},
	-- Whether the contents of a currently open hover window should be moved
	-- to a :h preview-window when pressing the hover keymap.
	preview_window = false,
	title = true,
	mouse_providers = {
		"LSP",
	},
	mouse_delay = 500,
}

local function hover()
	return require("hover")
end

---@type LazyKeysSpec[]
local keys = {
	{
		"K",
		mode = "n",
		function()
			hover().open()
		end,
		desc = "Hover doc",
	},
	-- Useless with noice or notify
	-- Use `<C-w>w` instead
	-- {
	--   "gk", mode = "n", function ()
	--     hover().select()
	--   end,
	--   desc = "Jump to hover doc"
	-- },
	{
		"<C-p>",
		mode = "n",
		function()
			hover().switch("previous")
		end,
		desc = "Previous source (Hover doc)",
	},
	{
		"<C-n>",
		mode = "n",
		function()
			hover().switch("next")
		end,
		desc = "Next source (Hover doc)",
	},
}

-- Mouse support
if profile.preference.mouse ~= "" then
	table.insert({
		"<MouseMove>",
		mode = "n",
		function()
			hover().mouse()
		end,
		desc = "Hover doc (Mouse)",
	})
end

---@type LazyPluginSpec
return {
	"lewis6991/hover.nvim",
	keys = keys,
	init = function()
		-- Mouse support
		if profile.preference.mouse ~= "" then
			vim.o.mousemoveevent = true
		end
	end,
	opts = profile.utils.merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
}
