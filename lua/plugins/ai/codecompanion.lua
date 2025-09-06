-- NOTE:
-- Run `checkhealth codecompanion` to check that plugin is working
-- Require `base64` binary for image/vision support
-- The plugin requires the `markdown` and `markdown_inline` Tree-sitter parsers to be installed with `:TSInstall markdown markdown_inline`

---@module "codecompanion"

local profile = require("profiles")
local merge_plugin_opts = profile.utils.merge_plugin_opts

local opts = {
	adapters = {
		http = {
			ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					schema = {
						num_ctx = {
							default = 16384,
						},
					},
				})
			end,
		},
	},
  display = {
    chat = {
      window = {
        layout = "vertical",
        position = "right",
        width = 0.35
      },
    },
  },
	strategies = {
		chat = {
			adapter = {
				name = "ollama",
				model = "qwen2.5-coder:7b",
			},
		},
		inline = {
			adapter = {
				name = "ollama",
				model = "qwen2.5-coder:1.5b",
			},
			keymaps = {
				accept_change = {
					modes = { n = "<LEADER>ca" },
					description = "Accept the suggested change",
				},
				reject_change = {
					modes = { n = "<LEADER>cr" },
					opts = { nowait = true },
					description = "Reject the suggested change",
				},
			},
		},
		cmd = {
			adapter = {
				name = "ollama",
				model = "qwen2.5-coder:7b",
			},
		},
	},
}

---@type LazyPluginSpec
return {
	"olimorris/codecompanion.nvim",
	cmd = {
		"CodeCompanion",
		"CodeCompanionCmd",
		"CodeCompanionChat",
		"CodeCompanionActions",
	},
	opts = merge_plugin_opts(Vkz.vkzlib.io.lua.get_caller_module_path(), opts),
	-- init = function()
	-- 	local cmp = require("cmp")
	-- 	cmp.setup.filetype({ "codecompanion" }, {
	-- 		sources = {
	-- 			{ name = "codecompanion" },
	-- 		},
	-- 	})
	-- end,
	keys = {
		{
			"<LEADER>ca",
			"<cmd>CodeCompanionActions<CR>",
			desc = "Open the action palette",
			mode = { "n", "v" },
		},
		{
			"<LEADER>cc",
			"<cmd>CodeCompanionChat Toggle<CR>",
			desc = "Toggle a chat buffer",
			mode = { "n", "v" },
		},
		{
			"<LEADER>cC",
			"<cmd>CodeCompanionChat Add<CR>",
			desc = "Add motion to a chat buffer",
			mode = { "v" },
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
}
