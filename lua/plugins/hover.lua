local profile = require("profiles")

---@type Hover.Config
local opts = {
	---List of modules names to load as providers.
	---@type (string | Hover.Config.Provider)[]
	providers = {
		"hover.providers.diagnostic",
		"hover.providers.lsp",
		"hover.providers.dap",
		'hover.providers.man',
		-- 'hover.providers.dictionary',
		"hover.providers.gh",
		"hover.providers.gh_user",
		-- 'hover.providers.jira',
		"hover.providers.fold_preview",
		-- 'hover.providers.highlight',
	},
	preview_opts = {
		border = "single",
	},
	-- Whether the contents of a currently open hover window should be moved
	-- to a :h preview-window when pressing the hover keymap.
	preview_window = false,
	title = true,
	mouse_providers = {
		"hover.providers.lsp",
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
		desc = "Hover doc / Next source",
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
