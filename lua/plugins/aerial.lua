local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local Groups = require("config.key_groups").Groups

local opts = {
	-- optionally use on_attach to set keymaps when aerial has attached to a buffer
	on_attach = function(bufnr)
		-- Jump forwards/backwards with '{' and '}'
		vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
	end,
	lazy_load = true,

	layout = {
		default_direction = "prefer_right",
	},

	close_on_select = true,
	show_guides = true,

	-- Keymaps in aerial window. Can be any value that `vim.keymap.set` accepts OR a table of keymap
	-- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
	-- Additionally, if it is a string that matches "actions.<name>",
	-- it will use the mapping at require("aerial.actions").<name>
	-- Set to `false` to remove a keymap
	-- keymaps = {
	-- 	["?"] = "actions.show_help",
	-- 	["g?"] = "actions.show_help",
	-- 	["<CR>"] = "actions.jump",
	-- 	["<2-LeftMouse>"] = "actions.jump",
	-- 	["<C-v>"] = "actions.jump_vsplit",
	-- 	["<C-s>"] = "actions.jump_split",
	-- 	["p"] = "actions.scroll",
	-- 	["<C-j>"] = "actions.down_and_scroll",
	-- 	["<C-k>"] = "actions.up_and_scroll",
	-- 	["{"] = "actions.prev",
	-- 	["}"] = "actions.next",
	-- 	["[["] = "actions.prev_up",
	-- 	["]]"] = "actions.next_up",
	-- 	["q"] = "actions.close",
	-- 	["o"] = "actions.tree_toggle",
	-- 	["za"] = "actions.tree_toggle",
	-- 	["O"] = "actions.tree_toggle_recursive",
	-- 	["zA"] = "actions.tree_toggle_recursive",
	-- 	["l"] = "actions.tree_open",
	-- 	["zo"] = "actions.tree_open",
	-- 	["L"] = "actions.tree_open_recursive",
	-- 	["zO"] = "actions.tree_open_recursive",
	-- 	["h"] = "actions.tree_close",
	-- 	["zc"] = "actions.tree_close",
	-- 	["H"] = "actions.tree_close_recursive",
	-- 	["zC"] = "actions.tree_close_recursive",
	-- 	["zr"] = "actions.tree_increase_fold_level",
	-- 	["zR"] = "actions.tree_open_all",
	-- 	["zm"] = "actions.tree_decrease_fold_level",
	-- 	["zM"] = "actions.tree_close_all",
	-- 	["zx"] = "actions.tree_sync_folds",
	-- 	["zX"] = "actions.tree_sync_folds",
	-- },
}

---@type LazyPluginSpec
return {
	"stevearc/aerial.nvim",
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	cmd = {
		"AerialToggle",
		"AerialOpen",
		"AerialOpenAll",
		"AerialClose",
		"AerialCloseAll",
		"AerialNext",
		"AerialPrev",
		"AerialGo",
		"AerialInfo",
		"AerialNavToggle",
		"AerialNavOpen",
		"AerialNavClose",
	},
	keys = {
		{
			Groups.UI.lhs .. "o",
			mode = "n",
			"<CMD>AerialToggle!<CR>",
			desc = "Toggle code outline (aerial)",
		},
		{
			Groups.Telescope.lhs .. "s",
			mode = "n",
			"<CMD>Telescope aerial<CR>",
			desc = "Symbols (Aerial)",
		},
	},
  config = function (_, o)
    require("aerial").setup(o)
    require("telescope").load_extension("aerial")
  end,
	dependencies = {

		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
	},
}
