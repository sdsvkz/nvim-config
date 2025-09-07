-- NOTE:
-- Run `checkhealth codecompanion` to check that plugin is working
-- Require `base64` binary for image/vision support
-- The plugin requires the `markdown` and `markdown_inline` Tree-sitter parsers to be installed with `:TSInstall markdown markdown_inline`

---@module "codecompanion"
---@module "vectorcode"

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
				width = 0.35,
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
	extensions = {
		history = {
			enabled = true,
			opts = {
				-- Picker interface (auto resolved to a valid picker)
				picker = "telescope",

				---Automatically generate titles for new chats
				auto_generate_title = true,
				title_generation_opts = {
					---Number of user prompts after which to refresh the title (0 to disable)
					refresh_every_n_prompts = 3,

					---Maximum number of times to refresh the title (default: 3)
					max_refreshes = 3,
				},

				-- Summary system
				summary = {},

				-- Memory system (requires VectorCode CLI)
				memory = {
					-- Automatically index summaries when they are generated
					auto_create_memories_on_summary_generation = true,

					-- Index all existing memories on startup
					-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
					index_on_startup = false,
				},
			},
		},
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				-- MCP Tools
				make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
				show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
				add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
				show_result_in_chat = true, -- Show tool results directly in chat buffer
				format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
				-- MCP Resources
				make_vars = true, -- Convert MCP resources to #variables for prompts
				-- MCP Prompts
				make_slash_commands = true, -- Add MCP prompts as /slash commands
			},
		},
		vectorcode = {
			enabled = true,
			---@type VectorCode.CodeCompanion.ExtensionOpts
			---@diagnostic disable-next-line: missing-fields
			opts = {
				tool_group = {
					-- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
					enabled = true,
					-- a list of extra tools that you want to include in `@vectorcode_toolbox`.
					-- if you use @vectorcode_vectorise, it'll be very handy to include
					-- `file_search` here.
					extras = {},
					collapse = false, -- whether the individual tools should be shown in the chat
				},
				tool_opts = {
					---@type VectorCode.CodeCompanion.ToolOpts
					["*"] = {},
					---@type VectorCode.CodeCompanion.LsToolOpts
					ls = {},
					---@type VectorCode.CodeCompanion.VectoriseToolOpts
					vectorise = {},
					---@type VectorCode.CodeCompanion.QueryToolOpts
					query = {
						max_num = { chunk = -1, document = -1 },
						default_num = { chunk = 50, document = 10 },
						use_lsp = true,
						no_duplicate = true,
						chunk_mode = false,
						---@type VectorCode.CodeCompanion.SummariseOpts
						---@diagnostic disable-next-line: missing-fields
						summarise = {
							---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
							enabled = false,
							---@diagnostic disable-next-line: assign-type-mismatch
							adapter = nil,
							query_augmented = true,
						},
					},
					files_ls = {},
					files_rm = {},
				},
				---@type table<string, VectorCode.CodeCompanion.PromptFactory.Opts>
				prompt_library = {},
			},
		},
	},
}

---@type LazyPluginSpec[]
return {
	{
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
			"nvim-telescope/telescope.nvim",
			"ravitemer/codecompanion-history.nvim",
			"Davidyz/VectorCode",
			"ravitemer/mcphub.nvim",
		},
	},
}
