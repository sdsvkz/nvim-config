local merge_plugin_opts = require("profiles.utils").merge_plugin_opts

local Groups = require("config.key_groups").Groups

---@module "nvim-tree"

local opts = {
	disable_netrw = true,
	hijack_netrw = true,
	sync_root_with_cwd = true,
	prefer_startup_root = false,
	view = {
		centralize_selection = true,
		width = {
			min = 25,
			max = 50,
		},
	},
	filesystem_watchers = {
		ignore_dirs = {
			"node_modules",
			"AppData",
		},
	},
	git = {
		enable = true,
		timeout = 5000,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		severity = {
			min = vim.diagnostic.severity.WARN,
		},
	},
	modified = {
		enable = true,
		show_on_dirs = true,
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	renderer = {
		full_name = true,
		highlight_git = "all",
		highlight_diagnostics = "all",
		highlight_modified = "all",
		indent_markers = {
			enable = true,
		},
		icons = {
			web_devicons = {
				folder = {
					enable = true,
				},
			},
		},
	},
}

return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			-- Make :bd and :q behave as usual when tree is visible
			-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#make-q-and-bd-work-as-if-tree-was-not-visible
			vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
				nested = false,
				callback = function(e)
					local tree = require("nvim-tree.api").tree

					-- Nothing to do if tree is not opened
					if not tree.is_visible() then
						return
					end

					-- How many focusable windows do we have? (excluding e.g. incline status window)
					local winCount = 0
					for _, winId in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_config(winId).focusable then
							winCount = winCount + 1
						end
					end

					-- We want to quit and only one window besides tree is left
					if e.event == "QuitPre" and winCount == 2 then
						vim.api.nvim_cmd({ cmd = "qall" }, {})
					end

					-- :bd was probably issued an only tree window is left
					-- Behave as if tree was closed (see `:h :bd`)
					if e.event == "BufEnter" and winCount == 1 then
						-- Required to avoid "Vim:E444: Cannot close last window"
						vim.defer_fn(function()
							-- close nvim-tree: will go to the last buffer used before closing
							tree.toggle({ find_file = true, focus = true })
							-- re-open nivm-tree
							tree.toggle({ find_file = true, focus = false })
						end, 10)
					end
				end,
			})
		end,
		opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
		keys = {
			{
				Groups.UI.lhs .. "e",
				mode = "n",
				"<CMD>NvimTreeToggle<CR>",
				desc = "Toggle file explorer",
			},

			{
				Groups.UI.lhs .. "E",
				mode = "n",
				"<CMD>NvimTreeFindFile<CR>",
				desc = "Show current file in file explorer",
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
}
